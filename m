From: Steve French <smfrench@gmail.com>
Subject: Fwd: [PATCH 7/7] CIFS: Fix error paths in writeback code
Date: Fri, 11 Jan 2019 00:24:54 -0600
Message-ID: <CAH2r5mt5NinzUbxtPz2M0qaU_6+MkaaEqD-UkrO-BRM=SZZ17Q@mail.gmail.com>
References: <1547159098-19011-1-git-send-email-pshilov@microsoft.com> <1547159098-19011-8-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pavel Shilovskiy <pshilov@microsoft.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>, bfoster@redhat.com,
        Jeff Layton <jlayton@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1547159098-19011-8-git-send-email-pshilov@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

These changes in writepage and writepages for cifs remind me of
loosely related writeback changes that Jeff and Brian have done in the
VFS/MM layer, so was hopeful that others might have comments if they
see anything missing from Pavel's patch.

---------- Forwarded message ---------
From: Pavel Shilovsky <piastryyy@gmail.com>
Date: Thu, Jan 10, 2019 at 4:25 PM
Subject: [PATCH 7/7] CIFS: Fix error paths in writeback code
To: <linux-cifs@vger.kernel.org>
Cc: Steve French <smfrench@gmail.com>, Ronnie Sahlberg <lsahlber@redhat.com>


This patch aims to address writeback code problems related to error
paths. In particular it respects EINTR and related error codes and
stores the first error occured during writeback in order to return it
to a caller.

Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/cifsglob.h | 19 +++++++++++++++++++
 fs/cifs/cifssmb.c  |  7 ++++---
 fs/cifs/file.c     | 29 +++++++++++++++++++++++------
 fs/cifs/inode.c    | 10 ++++++++++
 4 files changed, 56 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 7709268..94dbdbe 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1575,6 +1575,25 @@ static inline void free_dfs_info_array(struct
dfs_info3_param *param,
        kfree(param);
 }

+static inline bool is_interrupt_error(int error)
+{
+       switch (error) {
+       case -EINTR:
+       case -ERESTARTSYS:
+       case -ERESTARTNOHAND:
+       case -ERESTARTNOINTR:
+               return true;
+       }
+       return false;
+}
+
+static inline bool is_retryable_error(int error)
+{
+       if (is_interrupt_error(error) || error == -EAGAIN)
+               return true;
+       return false;
+}
+
 #define   MID_FREE 0
 #define   MID_REQUEST_ALLOCATED 1
 #define   MID_REQUEST_SUBMITTED 2
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index b1f49c1..6930cdb 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2114,7 +2114,7 @@ cifs_writev_requeue(struct cifs_writedata *wdata)

                for (j = 0; j < nr_pages; j++) {
                        unlock_page(wdata2->pages[j]);
-                       if (rc != 0 && rc != -EAGAIN) {
+                       if (rc != 0 && !is_retryable_error(rc)) {
                                SetPageError(wdata2->pages[j]);
                                end_page_writeback(wdata2->pages[j]);
                                put_page(wdata2->pages[j]);
@@ -2123,7 +2123,7 @@ cifs_writev_requeue(struct cifs_writedata *wdata)

                if (rc) {
                        kref_put(&wdata2->refcount, cifs_writedata_release);
-                       if (rc == -EAGAIN)
+                       if (is_retryable_error(rc))
                                continue;
                        break;
                }
@@ -2132,7 +2132,8 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
                i += nr_pages;
        } while (i < wdata->nr_pages);

-       mapping_set_error(inode->i_mapping, rc);
+       if (rc != 0 && !is_retryable_error(rc))
+               mapping_set_error(inode->i_mapping, rc);
        kref_put(&wdata->refcount, cifs_writedata_release);
 }

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index c23bf9d..109b1ef 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -732,7 +732,8 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)

        if (can_flush) {
                rc = filemap_write_and_wait(inode->i_mapping);
-               mapping_set_error(inode->i_mapping, rc);
+               if (!is_interrupt_error(rc))
+                       mapping_set_error(inode->i_mapping, rc);

                if (tcon->unix_ext)
                        rc = cifs_get_inode_info_unix(&inode, full_path,
@@ -2109,6 +2110,7 @@ static int cifs_writepages(struct address_space *mapping,
        pgoff_t end, index;
        struct cifs_writedata *wdata;
        int rc = 0;
+       int saved_rc = 0;
        unsigned int xid;

        /*
@@ -2137,8 +2139,10 @@ static int cifs_writepages(struct address_space *mapping,

                rc = server->ops->wait_mtu_credits(server, cifs_sb->wsize,
                                                   &wsize, &credits);
-               if (rc)
+               if (rc != 0) {
+                       done = true;
                        break;
+               }

                tofind = min((wsize / PAGE_SIZE) - 1, end - index) + 1;

@@ -2146,6 +2150,7 @@ static int cifs_writepages(struct address_space *mapping,
                                                  &found_pages);
                if (!wdata) {
                        rc = -ENOMEM;
+                       done = true;
                        add_credits_and_wake_if(server, credits, 0);
                        break;
                }
@@ -2174,7 +2179,7 @@ static int cifs_writepages(struct address_space *mapping,
                if (rc != 0) {
                        add_credits_and_wake_if(server, wdata->credits, 0);
                        for (i = 0; i < nr_pages; ++i) {
-                               if (rc == -EAGAIN)
+                               if (is_retryable_error(rc))
                                        redirty_page_for_writepage(wbc,
                                                           wdata->pages[i]);
                                else
@@ -2182,7 +2187,7 @@ static int cifs_writepages(struct address_space *mapping,
                                end_page_writeback(wdata->pages[i]);
                                put_page(wdata->pages[i]);
                        }
-                       if (rc != -EAGAIN)
+                       if (!is_retryable_error(rc))
                                mapping_set_error(mapping, rc);
                }
                kref_put(&wdata->refcount, cifs_writedata_release);
@@ -2192,6 +2197,15 @@ static int cifs_writepages(struct address_space *mapping,
                        continue;
                }

+               /* Return immediately if we received a signal during writing */
+               if (is_interrupt_error(rc)) {
+                       done = true;
+                       break;
+               }
+
+               if (rc != 0 && saved_rc == 0)
+                       saved_rc = rc;
+
                wbc->nr_to_write -= nr_pages;
                if (wbc->nr_to_write <= 0)
                        done = true;
@@ -2209,6 +2223,9 @@ static int cifs_writepages(struct address_space *mapping,
                goto retry;
        }

+       if (saved_rc != 0)
+               rc = saved_rc;
+
        if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
                mapping->writeback_index = index;

@@ -2241,8 +2258,8 @@ cifs_writepage_locked(struct page *page, struct
writeback_control *wbc)
        set_page_writeback(page);
 retry_write:
        rc = cifs_partialpagewrite(page, 0, PAGE_SIZE);
-       if (rc == -EAGAIN) {
-               if (wbc->sync_mode == WB_SYNC_ALL)
+       if (is_retryable_error(rc)) {
+               if (wbc->sync_mode == WB_SYNC_ALL && rc == -EAGAIN)
                        goto retry_write;
                redirty_page_for_writepage(wbc, page);
        } else if (rc != 0) {
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 5b883a0..ba1152b 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2260,6 +2260,11 @@ cifs_setattr_unix(struct dentry *direntry,
struct iattr *attrs)
         * the flush returns error?
         */
        rc = filemap_write_and_wait(inode->i_mapping);
+       if (is_interrupt_error(rc)) {
+               rc = -ERESTARTSYS;
+               goto out;
+       }
+
        mapping_set_error(inode->i_mapping, rc);
        rc = 0;

@@ -2403,6 +2408,11 @@ cifs_setattr_nounix(struct dentry *direntry,
struct iattr *attrs)
         * the flush returns error?
         */
        rc = filemap_write_and_wait(inode->i_mapping);
+       if (is_interrupt_error(rc)) {
+               rc = -ERESTARTSYS;
+               goto cifs_setattr_exit;
+       }
+
        mapping_set_error(inode->i_mapping, rc);
        rc = 0;

--
2.7.4



-- 
Thanks,

Steve
