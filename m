Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792975610;
	b=lyocYykakGGVC9SEGf/mDKhPiHQ54YTaWbm4K7/GQAL6/PVJ0bi32oZi5YHe9+Oh77Iz
	 Lpun6mKlVuaPFc1TYjLL+MUOESsrFrAkXkCbSxvu8Cjy7eWgD/Vp9gRZzIDFYy1+syMmx
	 ScK0lGNBQUPEGXI5VZWvSKFmeL0NgApwzS0TpxlMhVyqcHwAH0ZLTqd6bez2OCmH2cILb
	 D7ypGw0BPA6F2fI4CL4NeZ2C5QQ8qXTYQO742B7PLXy5YssUeEiswgP2TsO3pK38Ix1TW
	 HJX5O4juJUXkckXSi7P37hGm9Z0NIoGfDIKPQ/kQSox9hxs9tu+VM3WVXY4dhM8ZiXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792975610;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Qijv1dlEij20EdMeIbGpdMin8+1h12UwR2e2M8zTwrI=;
	b=Fv+lNCQ/SqgzrilY0beroAieXXby34xLDIxqPpfVdAnv+Vi1enW8GB2T5MRLIyDVfv6r
	 UM/O+yOUDGAEeKPjoOPGIleg2t2gUivN7Fr7WiN2Pe8nsGeF2LH3Nkdv7DKG9WuGvwLg3
	 +QMM8jUrvWSICoUkFia0JGvYK3bPartrShuLqQBziEAHeGMqxc2m9x25WtGJcyjQ/T/n/
	 is1nlNy0YboxYDcNg0j378J4xmSnwUpBHlOOWLEoXSHALbce/RwksgWo0DuUYLN9bqpZh
	 5sMi2XtAcpwC7Rs2GjvkJxkv7iGXbfRod8EHFAFbU3Sw70OX3d51NnHN4TQnLB4DJIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b="zpGmS/j9";
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF357606A31A;
	Mon, 26 Oct 2026 00:46:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF357606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=zpGmS/j9
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Qijv1dlEij20EdMeIbGpdMin8+1h12UwR2e2M8zTwrI=; b=zpGmS/j9i2Cgr9vpSPhJVrLTAg
	YviDm3y6laX1PP4pjoiOvMY09PC640fXrPxGDvlmyOgbbEnKECW7FFEKxt4V/NWjcmlWpbXPD41aZ
	TF7wgjR9Wxe6FH1FxKvPyfzAmOU/CvEZO5Jy2oQywxCG23+lCVUgZXNCvpw+gM9IifHZLxYdVxLpF
	LTtg7OyrQhJHZS2tQ6Xg5nSzv3YbiwsFVHr5RAxsRgFWOI9uyLG7ysGRiqGElNAcsNOlIhmNxeLMJ
	hXaUMHmatz4llHeY9ZAOhL7lVd9btiyx67NluhrhYsG0IcHt1puCJLf9KB7xfFUcJYh4At4NlmIFP
	Hrry8Fcw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xL8rL-000000001BJ-2JXR;
	Sun, 25 Oct 2026 21:46:44 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: don't resurrect an exiting tcon from cached dir workers
Date: Sun, 25 Oct 2026 21:46:44 -0300
Message-ID: <20261026004644.239554-1-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cfids_laundromat_worker() bumps tcon->tc_count for every expired open
cfid and queues cached_dir_offload_close() without checking whether the
tcon is already being torn down.  Racing with the final cifs_put_tcon(),
the tcon comes back from zero and gets torn down twice:

  T1                                  T2
  cifs_put_tcon()
   --tc_count == 0, TID_EXITING
   tconInfoFree()
    free_cached_dirs()
     cancel_delayed_work_sync()       cfids_laundromat_worker()
                                       ++tc_count == 1
                                       queue_work(serverclose_wq)
    kfree(tcon->origin_fullpath)
    kfree(tcon)
                                      cached_dir_offload_close()
                                       close_cached_dir()  [UAF]
                                       cifs_put_tcon()
                                        tconInfoFree()     [double free]

cached_dir_lease_break() also bumps tc_count without tc_lock, racing with
the laundromat's locked update.

Take the tcon reference through a helper that refuses once the tcon is
TID_EXITING or its refcount has dropped to zero.  Queued put_work and
close_work then always hold a tcon reference, so tconInfoFree() can't
run before they finish and free_cached_dirs() doesn't need to flush any
workqueue.  If the laundromat can't get a reference, put the cfid back on
the dying list for free_cached_dirs() to free; its handle goes away with
the tree connection.

The lease break path finds the tcon on ses->tcon_list under
cifs_tcp_ses_lock, so it can't see TID_EXITING, but it now takes tc_lock.

Fixes: 3fa640d035e5 ("smb: During unmount, ensure all cached dir instances drop their dentry")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cached_dir.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 647fa26da4d2..50217f47a0ed 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -649,6 +649,17 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon, bool sync)
 		flush_delayed_work(&cfids->laundromat_work);
 }
 
+static bool cached_dir_get_tcon(struct cifs_tcon *tcon,
+				enum smb3_tcon_ref_trace trace)
+{
+	guard(spinlock)(&tcon->tc_lock);
+	if (tcon->status == TID_EXITING || tcon->tc_count <= 0)
+		return false;
+	++tcon->tc_count;
+	trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count, trace);
+	return true;
+}
+
 static void
 cached_dir_offload_close(struct work_struct *work)
 {
@@ -693,6 +704,9 @@ bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 		    !memcmp(lease_key,
 			    cfid->fid.lease_key,
 			    SMB2_LEASE_KEY_SIZE)) {
+			if (!cached_dir_get_tcon(tcon,
+						 netfs_trace_tcon_ref_get_cached_lease_break))
+				break;
 			cfid->has_lease = false;
 			cfid->time = 0;
 			/*
@@ -703,9 +717,6 @@ bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 			cfid->on_list = false;
 			cfids->num_entries--;
 
-			++tcon->tc_count;
-			trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
-					    netfs_trace_tcon_ref_get_cached_lease_break);
 			queue_work(cfid_put_wq, &cfid->put_work);
 			spin_unlock(&cfids->cfid_list_lock);
 			return true;
@@ -813,12 +824,13 @@ static void cfids_laundromat_worker(struct work_struct *work)
 		cfid->dentry = NULL;
 
 		if (cfid->is_open) {
-			spin_lock(&cfid->tcon->tc_lock);
-			++cfid->tcon->tc_count;
-			trace_smb3_tcon_ref(cfid->tcon->debug_id, cfid->tcon->tc_count,
-					    netfs_trace_tcon_ref_get_cached_laundromat);
-			spin_unlock(&cfid->tcon->tc_lock);
-			queue_work(serverclose_wq, &cfid->close_work);
+			if (cached_dir_get_tcon(cfid->tcon,
+						netfs_trace_tcon_ref_get_cached_laundromat)) {
+				queue_work(serverclose_wq, &cfid->close_work);
+				continue;
+			}
+			scoped_guard(spinlock, &cfids->cfid_list_lock)
+				list_add_tail(&cfid->entry, &cfids->dying);
 		} else
 			/*
 			 * Drop the ref-count from above, either the lease-ref (if there
-- 
2.56.0

