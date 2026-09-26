Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611592DA74C
	for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 21:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790457392; cv=none; b=ly532M6G+PJVpCNXcSU452gDLhN26tGAGEzhWQPoC0lDa3OCc9y6ur3NWTmXkWM1YGRnCKdqkbbT93CrXueMZR4O3zROav692wRXyTYYDk32vXal7rs01syNVrGP2kHCdFirWmplANuYX8cOrbagTXLnbmoMI/UQtdFiQmhEtg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790457392; c=relaxed/simple;
	bh=4UTQiEMjWidutI42ppI1fo9O7I3c5UO5orC9tJPYIgg=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Rj7K4ckNMllkOAbf3J7y8DaJcRaJHM4l0BExrCR76033WjwF7TaAlhVvsf3ro+LQ9GX5zSIY19KVG5FYLJMqajp3qGeQl969ZiNmB4deC6qxuK4ZKvtcc/Tt5cc6e461F996E6vED/Bwy6mSch0mLssyDejAC/Jeh0kDF1pZzKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VklKBhcq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=h5yKOY14; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VklKBhcq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="h5yKOY14"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790457389;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
	bh=CBnNWVk3qgiTs+WKJRWI+4BrH/2BduAJsOfySc2aM4M=;
	b=VklKBhcqyYuNpHrhu7hq2Ev0J0fZOArn6Wrjwknsb8TwTI+BjUFcn30Fw+31iHR5mokE5v
	8Iojs4SpzhE/NA7Ebnah+XCihKBJoWbT/Sqc1Mwh6qm3QCgLx4ribQwVx/PY1mFqBM9Bdq
	COIqD4T3qVoI+keJMphQpdhBUzdqb6A=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-421-bXg2VYkmP0qBPdOlzpHE5Q-1; Sat, 26 Sep 2026 17:16:27 -0400
X-MC-Unique: bXg2VYkmP0qBPdOlzpHE5Q-1
X-Mimecast-MFC-AGG-ID: bXg2VYkmP0qBPdOlzpHE5Q_1790457387
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-9104eedb5b0so41569876d6.0
        for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 14:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790457387; x=1791062187; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:reply-to:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CBnNWVk3qgiTs+WKJRWI+4BrH/2BduAJsOfySc2aM4M=;
        b=h5yKOY14OfLmH8U/4ICxy8FDTwdToc6/6aAUwT82poTgi5Y1ZaQYfowY9awtcJtHy5
         szcHgowZ9hCk1dG9mNAmbcOXRgPNNBdjBl2qz7KmQZllkUEp9Jt1qT+8KyRv6XMrEd57
         fKWTEWpE7Bsdy+msW3lKPuz4UjRfKP/x/M2CMfdv63sJeuW2NsHZhnLj8XDHfMBeV8iS
         mC4ZDJxXgwXfdOllKD7OvIisw9Vvm+dWR2gMJ8Ei435dCXn84TkSH1fAWCHtq3XX+4f6
         awzzvafYKq8oeaV56nkPLbdCQ1JZB8ce5oFxbm2pQTfUxm5smr0Eqje2Fa1qIrWwVIAq
         dmlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790457387; x=1791062187;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:reply-to:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=CBnNWVk3qgiTs+WKJRWI+4BrH/2BduAJsOfySc2aM4M=;
        b=huACnTsX7ovPjJRVqEpv8jd4O5xk536c8+WftQLs0dYr44R12ypsn6fIamxiKsNm70
         zr+hsc0KhQu7x80UHCJI8Zm5IEEvRkOvRydLK4ZOygtNxshtrgd2r5T7iMIzakt4JZqq
         w3aYOJA3PUq0OmfwQxOCIxQQoFtFvlPPYFgWBCIQgqx1H1xdunfLmuYirlNs+QxSkCil
         J65tGTGTkOYNYiZotj+DsFl8Woggj3Fx/JNzTaR6cPNQHORhxOi6yZsQsgE5jOyXOKZ1
         IQVK3K9le2Wq0jY1pBkiklD4XigewHsdepuz+cIDt5GQYBEFBt1SKzSPvEAlJzMQpsUe
         6Hsw==
X-Gm-Message-State: AFuF++lNSMQ0K/Re3u3MkB/OlKTNxv9TNb4GRibt+CHO/Z00tZQWORd5
	B7SZ82zLB/PV0o0WQHt1zqTcxjyR1uIq2xV/G/tKnQSW2uOZMQGst09zAZv8fy7fIs4LPnUL2Lp
	RB3UDrL0mADwkC43FSKF+U1Cn9s7xPP1A1r9WwwdCA982OXZtbxPZC9lIyJGFpS7SvOzMokIn8O
	Xtk99vmAl8TBILlAjPdWBax5CyqF6OqnQS7HvAudWUhTChCTk=
X-Gm-Gg: AYBFou0mTehwOF9UVM46p4YnKGLr6tZodfOJpUF/VLYCLPJ1KDcplCujsFlDXDsJwM2
	VOIfnqD5DK4jzuT969Ra7uSH5Ww0tR0WyTf6QUPeRBnWn2rqd0PsfBkpNEUE7axSSkXH47iYWxc
	0LsrXF5Ah7kJDkZ6fZ5FHTmBy0rlqN2o9OBh6913vrrXbLRqSGYl3TW2GlBTO9aCti9FPlAftS/
	Ir/5FofndSMJETMK45KfzA+rF2xHMtACRlVel35aItWew0SUUFJpEOegZScmgv8So3yOcB912DY
	RURbYhg52gHpntIn6mtclwA+8Br0dvMe/IeAOc2zXhf9EnKxaK5l4wi07mq+7wmobE3DboGBTkN
	mw8yfaINNOGsuzCvN4NnMZhWgi+Rwf8AmLGEGuQWg
X-Received: by 2002:ad4:5948:0:b0:914:2c91:14f with SMTP id 6a1803df08f44-9142f8cb4d0mr119884376d6.14.1790457386887;
        Sat, 26 Sep 2026 14:16:26 -0700 (PDT)
X-Received: by 2002:ad4:5948:0:b0:914:2c91:14f with SMTP id 6a1803df08f44-9142f8cb4d0mr119883966d6.14.1790457386427;
        Sat, 26 Sep 2026 14:16:26 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9143d0a64b9sm34607996d6.35.2026.09.26.14.16.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Sep 2026 14:16:26 -0700 (PDT)
Message-ID: <7689764e-c0f6-4016-9557-b54cf4a3de4e@redhat.com>
Date: Sat, 26 Sep 2026 16:16:25 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sorenson@redhat.com
Content-Language: en-US
To: CIFS <linux-cifs@vger.kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>
From: Frank Sorenson <sorenson@redhat.com>
Subject: [Discuss] smb: client: bitfield aliasing and locking chaos in
 cifsFileInfo
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi all,

I ran xfstests on cifs/cifs-next (7.3-rc3+) with KCSAN enabled, and caught
a number of data races in the smb client.

The most concerning finding is a structural bitfield aliasing issue in
'struct cifsFileInfo'.

KCSAN caught a 1-byte write in '_cifsFileInfo_put' racing with a read in
'cifs_close':

   BUG: KCSAN: data-race in _cifsFileInfo_put [cifs] / cifs_close [cifs]

   write to 0xffff... of 1 bytes: _cifsFileInfo_put (file.c:885)
   read  to 0xffff... of 1 bytes: cifs_close (file.c:1495)

  885         cifs_file->offload = offload;
1495                 if ((cfile->status_file_deleted == false) &&


It also caught the same write racing with a read in 'cifs_prepare_write':

BUG: KCSAN: data-race in _cifsFileInfo_put [cifs] / cifs_prepare_write [cifs]

  write to 0xffff... of 1 bytes: _cifsFileInfo_put (file.c:885)
  read  to 0xffff... of 1 bytes: cifs_prepare_write (file.c:71)

  885         cifs_file->offload = offload;
   71         if (open_file->invalidHandle) {


In both cases, the read and write are to different fields of
'cifsFileInfo'.  However there are 5 consecutive 'bool:1' fields which all
share the same byte::

   bool invalidHandle:1;          /* bit 0 */
   bool swapfile:1;               /* bit 1 */
   bool oplock_break_cancelled:1; /* bit 2 */
   bool status_file_deleted:1;    /* bit 3 */
   bool offload:1;                /* bit 4 */


Since these bits all share the same byte, every write to any of these bits
becomes a byte-level read-modify-write cycle.


Looking at the codebase, the locking for these seems highly inconsistent.
For example, `invalidHandle` is sometimes written lockless, while
`oplock_break_cancelled` is written under either `file_info_lock` or
`tcon->open_file_lock`.  If any two of these write paths execute concurrently,
the byte-level RMW will silently discard one of the writes and corrupt the
bitfield.


It seems to me that we need to drop the ':1' from all 5 fields, eliminating the
byte-level aliasing entirely.

Beyond that, the access map (below) shows that the locking may need to be cleaned
up.  What is the intended locking for each of these fields?


Frank

Access map for the 5 bits across the client tree (excluding the single-threaded init writes):
   file:line              function                         R/W  lock held
   ---------              --------                         ---  ---------
invalidHandle:
   file.c:71              cifs_prepare_write               R    none
   file.c:128             cifs_issue_write                 R    none
   file.c:225             cifs_issue_read                  R    none
   file.c:397             cifs_mark_open_files_invalid     W=T  tcon->open_file_lock
   file.c:932             _cifsFileInfo_put                R    none (after unlock)
   file.c:1292            cifs_reopen_file                 R    fh_mutex
   file.c:1408            cifs_reopen_file                 W=F  fh_mutex
   file.c:1559            cifs_reopen_persistent_handles   R    tcon->open_file_lock
   file.c:1595            cifs_closedir                    W=T  file_info_lock
   file.c:2677            __find_readable_file             R    cifs_inode->open_file_lock
   file.c:2750            __cifs_get_writable_file         R    cifs_inode->open_file_lock
   readdir.c:45           dump_cifs_file_struct            R    none (debug)
   readdir.c:395          _initiate_cifs_search            W=T  none
   readdir.c:427          _initiate_cifs_search            W=F  none
   readdir.c:735          find_cifs_entry                  W=T  file_info_lock
   smb1ops.c:1283 (cb)    cifs_dir_needs_close             R    file_info_lock (caller)
   smb2ops.c:4606 (cb)    smb2_dir_needs_close             R    file_info_lock (caller)
oplock_break_cancelled:
   file.c:398             cifs_mark_open_files_invalid     W=T  tcon->open_file_lock
   file.c:3420            cifs_oplock_break                R    none
   smb1misc.c:162         is_valid_oplock_break            W=F  tcon->open_file_lock
   smb2misc.c:605         smb2_tcon_has_lease              W=F  tcon->open_file_lock
   smb2misc.c:607         smb2_tcon_has_lease              W=T  tcon->open_file_lock
   smb2misc.c:774         smb2_is_valid_oplock_break       W=T  file_info_lock
   smb2misc.c:776         smb2_is_valid_oplock_break       W=F  file_info_lock
offload:
   file.c:833             serverclose_work                 R    none
   file.c:885             _cifsFileInfo_put                W    tcon->open_file_lock +
                                                                 cifsi->open_file_lock +
                                                                 file_info_lock
status_file_deleted:
   file.c:1495            cifs_close                       R    none
   file.c:2670            __find_readable_file             R    cifs_inode->open_file_lock
   file.c:2743            __cifs_get_writable_file         R    cifs_inode->open_file_lock
   misc.c:675             cifs_mark_open_handles_for_deleted_file  W=T  cinode->open_file_lock
   misc.c:679             cifs_mark_open_handles_for_deleted_file  W=T  cinode->open_file_lock
swapfile:
   file.c:3510            cifs_swap_activate               W=T  none
   file.c:3528            cifs_swap_deactivate             W=F  none
   cifsfs.c:1648          cifs_copy_file_range             R    none


-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

