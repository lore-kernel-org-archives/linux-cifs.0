Received: from mail.der-he.de (mail.der-he.de [188.68.35.236])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4290714AA9
	for <linux-cifs@vger.kernel.org>; Sat,  2 Aug 2025 08:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.35.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754123486; cv=none; b=ltgnBoV1XVJQnMf3rt4y6QG4aXfV2Tz9EacWZlCvhVSGtrrGgrh42DFyCUHV6X0nIQsERNgUlo0qDmDf9TwDnAaPs/7wSo2W/47wxg8U/kpTvoGjOTY3klnuA9mu+HsHk5LOBLr0U4LP1Bxz3BCylquiWwXrSiOqgsRwgJZSIQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754123486; c=relaxed/simple;
	bh=k/0w91/cRLJK2okgg/RbFr6GDti3V/ZL9Opn+0AuXp8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TIzdtzJNOU4sDcAU/hQywpN9cLFdspMhG/YTs6Ew87FpWdvOb16eey12Z4qNbhlk4iez1N2Bfutf7anBWlRRru1Unx92Voff9B6lyN2GMYedk+uEng3aHWnCm18bwIgqFqZF8I7isTohgKLDRVm93fHp3yUhwLdHLBKeenPl9RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=der-he.de; spf=pass smtp.mailfrom=der-he.de; arc=none smtp.client-ip=188.68.35.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=der-he.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=der-he.de
Received: from homekolab.der-he.de (unknown [IPv6:2001:9e8:46e1:3000:2ff:2bff:fe1c:3849])
	by mail.der-he.de (Postfix) with ESMTPS id EEB8FDFBBC;
	Sat,  2 Aug 2025 10:31:17 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at der-he.de
Date: Sat, 2 Aug 2025 10:31:13 +0200
From: hede <debian452@der-he.de>
To: Ralph Boehme via samba <samba@lists.samba.org>
Cc: Ralph Boehme <slow@samba.org>, CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [Samba] delayed mtime updates: configurable?
Message-ID: <20250802103113.0e12da0a@hpusdt5.der-he.de>
In-Reply-To: <d93fd05d-aacb-4163-a4be-fe1ee57c3c48@samba.org>
References: <20250727184517.577dd1f0@hpusdt5.der-he.de>
	<20250801113523.76290fc7@hpusdt5.der-he.de>
	<d0508d0a-fb13-4a40-b27b-e55e30fa33d4@samba.org>
	<20250801155827.36e722ef@hpusdt5.der-he.de>
	<d93fd05d-aacb-4163-a4be-fe1ee57c3c48@samba.org>
Organization: der-he.de
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 1 Aug 2025 18:23:22 +0200 Ralph Boehme via samba <samba@lists.samba.org> wrote:

> it does it once, before the write. Unfortunately that means sticky mtime 
> is in effect which means the time explicitly set is "sticky" and any 
> subsequent write must not update the mtime but the explicitly set mtime 
> must be preserved. 

What I can observe here is, the time "preserved" on server side, for the file in the file system on disk, before the final close happens, seems to be some file creation time. None of the client timestamps. The client-sent "sticky" time then seems to get applied only in the end, after the final close. 
I think it should get applied earlier. 

Watching the filesystems directly at client- and server side, the timing of events, is as follows.

mounted via cifs.ko as smb3 with closetimeo=2. 

I'm watching the file via: 
# LANG=C watch -n 0.1 "stat test.txt | grep Modif" 
 - recording a video, analysing afterwards
 - so I probably miss timestamp changes which last less then 0.1 seconds
 
Result:

- given: old file with mtime timestamp 09:23.51.710232900
- both on server and client
- open file in vim, write changes to file
- mtime on client changes to           09:25:34.795869100
- mtime on server firstly remains at   09:23.51.710232900
- mtime on server then changes to      09:25:34.828869245
  (here probably the client already changes the mtime to 09:25:34.823598700 for a short interval, I missed that)
- mtime on client then changes to      09:25:34.856599400
  (this one seems to be the one done in the cifs_close()-function)
- ~2 seconds later (probably the closetimeo interval)
- mtime on server changes to           09:25:34.823598700
- mtime on client changes to           09:25:34.823598700

Watching the file in filesysteme, mtime timestamp of the file on client side changes:
x.71 -> x.79 -> x.85 -> wait 2 seconds -> x.82
-> and vim is complaining that the file has changed while it is opened

With the patches (dirty hack) below, this changes to:

- given: old file with mtime timestamp 09:37:45.099864000
- both on server and client
- open file in vim, write changes to file
- mtime on client changes to           09:39:03.670403100
- mtime on server changes to           09:39:03.670403108 
  (this one I probably missed in the unpatched case above)
- mtime on server changes to           09:39:03.758403493
- mtime on client changes to           09:39:03.754924500
- ~2 seconds later (probably the closetimeo interval)
- mtime on server changes to           09:39:03.754924500

So watching the file in the filesystem on client side now results in:
x.09 -> x.67 -> 0x75 (all within 0.1 seconds)
-> still some 2-seconds-wait on server side
-> no 2-second-wait on client side
-> vim is not complaining
-> still there are multiple updates of the mtime within a short time frame. 

Those probably dirty hacks with side effects are just to show the differences, they are NOT meant as a solution. But I think it shows that there is some kind of a bug/issue here and consequently I think SMB3 UNIX Extensions is not the only option to fix this.

I do not understand why the mtime setting gets delayed at all with the deferred close functionality. Shouldn't they applied independently of each other? The server gets the final timestamp already before this (this is visible via some tcpdump/pcap).

########## (here for Linux 6.1 as in chomeos-6.1) ##########

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 9b0919d9e337..644ff6595cf1 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1042,9 +1042,9 @@ int cifs_close(struct inode *inode, struct file *file)
                    && cinode->lease_granted &&
                    !test_bit(CIFS_INO_CLOSE_ON_LOCK, &cinode->flags) &&
                    dclose) {
-                       if (test_and_clear_bit(CIFS_INO_MODIFIED_ATTR, &cinode->flags)) {
-                               inode->i_ctime = inode->i_mtime = current_time(inode);
-                       }
+                       //if (test_and_clear_bit(CIFS_INO_MODIFIED_ATTR, &cinode->flags)) {
+                       //      inode->i_ctime = inode->i_mtime = current_time(inode);
+                       //}
                        spin_lock(&cinode->deferred_lock);
                        cifs_add_deferred_close(cfile, dclose);
                        if (cfile->deferred_close_scheduled &&
@@ -4976,8 +4976,8 @@ static int cifs_readpage_worker(struct file *file, struct page *page,
        file_inode(file)->i_atime = current_time(file_inode(file));
        if (timespec64_compare(&(file_inode(file)->i_atime), &(file_inode(file)->i_mtime)))
                file_inode(file)->i_atime = file_inode(file)->i_mtime;
-       else
-               file_inode(file)->i_atime = current_time(file_inode(file));
+       //else
+       //      file_inode(file)->i_atime = current_time(file_inode(file));
 
        if (PAGE_SIZE > rc)
                memset(read_data + rc, 0, PAGE_SIZE - rc);

########## (here for Linux 6.15 as in Arch Linux 6.15.9-arch1) ##########

--- file.c.ori  2025-08-02 08:31:47.006763652 +0200
+++ file.c      2025-08-02 08:32:04.557978347 +0200
@@ -1379,10 +1379,10 @@ int cifs_close(struct inode *inode, stru
                dclose = kmalloc(sizeof(struct cifs_deferred_close), GFP_KERNEL);
                if ((cfile->status_file_deleted == false) &&
                    (smb2_can_defer_close(inode, dclose))) {
-                       if (test_and_clear_bit(NETFS_ICTX_MODIFIED_ATTR, &cinode->netfs.flags)) {
-                               inode_set_mtime_to_ts(inode,
-                                                     inode_set_ctime_current(inode));
-                       }
+                       //if (test_and_clear_bit(NETFS_ICTX_MODIFIED_ATTR, &cinode->netfs.flags)) {
+                       //      inode_set_mtime_to_ts(inode,
+                       //                            inode_set_ctime_current(inode));
+                       //}
                        spin_lock(&cinode->deferred_lock);
                        cifs_add_deferred_close(cfile, dclose);
                        if (cfile->deferred_close_scheduled &&

##########

