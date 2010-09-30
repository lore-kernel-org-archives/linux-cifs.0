From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/17] autofs4 - fix wait validation
Date: Thu, 30 Sep 2010 19:16:12 +0100
Message-ID: <20100930181612.30939.30493.stgit@warthog.procyon.org.uk>
References: <20100930181455.30939.53914.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-fs@vger.kernel.org, autofs@linux.kernel.org,
	linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	Ian Kent <raven@themaw.net>,
	David Howells <dhowells@redhat.com>
To: viro@ftp.linux.org.uk, jmoyer@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100930181455.30939.53914.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Ian Kent <raven@themaw.net>

It is possible for the check in wait.c:validate_request() to return
an incorrect result if the dentry that was mounted upon has changed
during the callback.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/autofs4/waitq.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 2341375..f3792ff 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -296,6 +296,9 @@ static int validate_request(struct autofs_wait_queue **wait,
 	 * completed while we waited on the mutex ...
 	 */
 	if (notify == NFY_MOUNT) {
+		struct dentry *new = NULL;
+		int valid = 1;
+
 		/*
 		 * If the dentry was successfully mounted while we slept
 		 * on the wait queue mutex we can return success. If it
@@ -303,8 +306,20 @@ static int validate_request(struct autofs_wait_queue **wait,
 		 * a multi-mount with no mount at it's base) we can
 		 * continue on and create a new request.
 		 */
+		if (!IS_ROOT(dentry)) {
+			if (dentry->d_inode && d_unhashed(dentry)) {
+				struct dentry *parent = dentry->d_parent;
+				new = d_lookup(parent, &dentry->d_name);
+				if (new)
+					dentry = new;
+			}
+		}
 		if (have_submounts(dentry))
-			return 0;
+			valid = 0;
+
+		if (new)
+			dput(new);
+		return valid;
 	}
 
 	return 1;
