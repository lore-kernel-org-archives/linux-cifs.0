From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: create a new Documentation/ directory and move docfiles into it
Date: Thu,  5 Sep 2013 08:39:31 -0400
Message-ID: <1378384771-2023-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, we have a number of documentation files that live under
fs/cifs/. Generally, these don't get picked up by distro packagers,
since they're in a non-standard location. Move them to a new spot
under Documentation/ instead.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 {fs/cifs => Documentation/filesystems/cifs/AUTHORS}/AUTHORS | 0
 {fs => Documentation/filesystems}/cifs/CHANGES              | 0
 {fs => Documentation/filesystems}/cifs/README               | 0
 {fs => Documentation/filesystems}/cifs/TODO                 | 0
 Documentation/filesystems/{ => cifs}/cifs.txt               | 0
 5 files changed, 0 insertions(+), 0 deletions(-)
 rename {fs/cifs => Documentation/filesystems/cifs/AUTHORS}/AUTHORS (100%)
 rename {fs => Documentation/filesystems}/cifs/CHANGES (100%)
 rename {fs => Documentation/filesystems}/cifs/README (100%)
 rename {fs => Documentation/filesystems}/cifs/TODO (100%)
 rename Documentation/filesystems/{ => cifs}/cifs.txt (100%)

diff --git a/fs/cifs/AUTHORS b/Documentation/filesystems/cifs/AUTHORS/AUTHORS
similarity index 100%
rename from fs/cifs/AUTHORS
rename to Documentation/filesystems/cifs/AUTHORS/AUTHORS
diff --git a/fs/cifs/CHANGES b/Documentation/filesystems/cifs/CHANGES
similarity index 100%
rename from fs/cifs/CHANGES
rename to Documentation/filesystems/cifs/CHANGES
diff --git a/fs/cifs/README b/Documentation/filesystems/cifs/README
similarity index 100%
rename from fs/cifs/README
rename to Documentation/filesystems/cifs/README
diff --git a/fs/cifs/TODO b/Documentation/filesystems/cifs/TODO
similarity index 100%
rename from fs/cifs/TODO
rename to Documentation/filesystems/cifs/TODO
diff --git a/Documentation/filesystems/cifs.txt b/Documentation/filesystems/cifs/cifs.txt
similarity index 100%
rename from Documentation/filesystems/cifs.txt
rename to Documentation/filesystems/cifs/cifs.txt
-- 
1.8.3.1
