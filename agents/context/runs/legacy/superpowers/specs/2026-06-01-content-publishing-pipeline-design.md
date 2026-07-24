# Content Publishing Pipeline Design

Date: 2026-06-01

## Context

This spec defines the first content publishing pipeline for Allan B. Pedin IV's social channels. The pipeline should streamline scheduling content onto platform-native queues so posts happen later without an agent-side cron or manual follow-up at publish time.

n8n is the automation runtime. The live n8n instance has working MCP access, one personal project, no existing workflows, no credentials, and no data tables. V1 should start from that clean slate.

## Goal

Build a reusable n8n intake and publishing workflow that accepts a title and uploaded media, schedules supported platforms immediately on submit, records the outcome, and exposes clear failure states when a platform cannot be scheduled.

## V1 Scope

V1 creates one workflow: **Content Intake -> YouTube Schedule**.

The workflow publishes nothing immediately. It creates a platform-native scheduled post by uploading to YouTube with a future `publishAt` value. YouTube owns the future publish after the workflow succeeds.

## Required Input

The public n8n form collects:

- `title`: required text.
- `media`: required single file upload. V1 supports video for YouTube scheduling.
- `description`: optional textarea.
- `scheduled_at`: required date/time.
- `platforms`: required platform selection. V1 enables YouTube only.
- `emoji_left`: optional text, defaults to `🎲`.
- `emoji_right`: optional text, defaults to `🎲`.

The canonical title sent to platforms is:

```text
<emoji_left> <title> <emoji_right>
```

When emoji fields are blank, V1 uses `🎲` on both sides rather than generating new copy. Descriptions remain optional and should be passed through only when provided. Form schedule input is interpreted in `America/New_York` unless n8n returns an explicit timezone-aware value.

## Architecture

The workflow has five responsibilities:

1. **Form intake**: receive title, media, optional description, scheduled time, and platform selection.
2. **Validation**: reject missing title, missing media, invalid schedule time, unsupported platform, and unsupported media/platform pair.
3. **Tracking**: create a row in an n8n Data Table for the content package before external publishing side effects.
4. **YouTube adapter**: upload video through the native YouTube node with `privacyStatus: private` and `publishAt: scheduled_at`.
5. **Result recording**: update or append scheduling result fields including platform, status, scheduled time, video ID, URL when available, and error message when blocked or failed.

## Data Model

Use n8n Data Tables for V1 persistence because they require no external database credentials.

Create a `content_packages` table with:

- `content_key`: stable generated key for this submission.
- `title`: raw title from form.
- `platform_title`: emoji-wrapped title.
- `description`: optional description.
- `media_type`: `video` or `image`.
- `media_filename`: original uploaded filename.
- `scheduled_at`: requested future publish time.
- `platforms`: selected platforms as a string or JSON string.
- `overall_status`: `received`, `scheduled`, `partially_scheduled`, `blocked`, or `failed`.
- `created_at`: workflow receipt timestamp.

Create a `platform_schedule_results` table with:

- `content_key`: references the intake package.
- `platform`: `youtube` in V1.
- `status`: `scheduled`, `blocked_missing_credentials`, `blocked_unsupported_media`, `blocked_unsupported_platform`, `failed`.
- `scheduled_at`: requested publish time.
- `platform_post_id`: YouTube video ID when available.
- `platform_url`: YouTube URL when available.
- `error_message`: concise failure reason when applicable.
- `created_at`: result timestamp.

## YouTube Adapter

Use the native `n8n-nodes-base.youTube` node for V1. The node supports `resource: video`, `operation: upload`, binary input, title, category, description, `privacyStatus`, and `publishAt`.

The adapter should:

- Require a YouTube OAuth credential in n8n.
- Accept only video media.
- Upload the form binary field.
- Set the title to the emoji-wrapped platform title.
- Set description only when provided.
- Set the YouTube category to Science & Technology.
- Set `privacyStatus: private`.
- Set `publishAt` to the requested schedule time.
- Disable subscriber notifications unless explicitly changed later.

## Failure Behavior

Validation failures should return a clear form response and record a blocked result when enough data exists to create a tracking row.

Credential failures should be explicit. If the YouTube credential does not exist or is not authorized, the workflow should mark the YouTube result as `blocked_missing_credentials` or `failed` with a concise error.

Platform adapter gaps should not crash the intake workflow. Future selected platforms that are not implemented should be recorded as `blocked_unsupported_platform`.

YouTube image submissions should be recorded as `blocked_unsupported_media`, because YouTube scheduling in V1 is video-only.

## Testing And Verification

Before publication:

- Validate the workflow through n8n MCP `validate_workflow`.
- Use pin-data tests for successful video submission, missing title, missing media, unsupported image-for-YouTube, and unsupported platform.
- Keep the workflow unpublished until validation passes.

After credentials are connected and publication is authorized:

- Publish the workflow.
- Submit one production-safe test video scheduled in the future.
- Verify the workflow execution succeeded.
- Verify the content package and platform schedule result rows were written.
- Verify YouTube shows the video as scheduled with the expected title and time.

## Extension Contract

Future platform adapters must consume the same canonical package:

- title
- media
- optional description
- scheduled time
- platform selection

Each adapter should independently return:

- platform name
- scheduled/blocked/failed status
- platform post ID or URL when available
- concise error message when blocked or failed

The next adapters should be added one at a time in feasibility order: LinkedIn, X, Facebook, TikTok, Instagram.

## Out Of Scope

- Notion import.
- AI-generated descriptions or captions.
- Multi-account routing.
- Content approval workflows.
- Agent-side scheduled publishing at publish time.
- Browser-assisted platform scheduling.
- Image posting to YouTube.
- Automatic retries beyond n8n's normal execution behavior.
