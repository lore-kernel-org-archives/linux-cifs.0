From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] cifs: create a new Documentation/ directory and move docfiles into it
Date: Thu,  5 Sep 2013 08:45:39 -0400
Message-ID: <1378385139-2306-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

v2: fix destination of AUTHORS file

Currently, we have a number of documentation files that live under
fs/cifs/. Generally, these don't get picked up by distro packagers,
since they're in a non-standard location. Move them to a new spot
under Documentation/ instead.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 {fs => Documentation/filesystems}/cifs/AUTHORS | 0
 {fs => Documentation/filesystems}/cifs/CHANGES | 0
 {fs => Documentation/filesystems}/cifs/README  | 0
 {fs => Documentation/filesystems}/cifs/TODO    | 0
 Documentation/filesystems/{ => cifs}/cifs.txt  | 0
 5 files changed, 0 insertions(+), 0 deletions(-)
 rename {fs => Documentation/filesystems}/cifs/AUTHORS (100%)
 rename {fs => Documentation/filesystems}/cifs/CHANGES (100%)
 rename {fs => Documentation/filesystems}/cifs/README (100%)
 rename {fs => Documentation/filesystems}/cifs/TODO (100%)
 rename Documentation/filesystems/{ => cifs}/cifs.txt (100%)

diff --git a/fs/cifs/AUTHORS b/Documentation/filesystems/cifs/AUTHORS
similarity index 100%
rename from fs/cifs/AUTHORS
rename to Documentation/filesystems/cifs/AUTHORS
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
