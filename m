Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C365E374D1
	for <linux-cifs@vger.kernel.org>; Thu, 15 Aug 2024 03:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723693591; cv=none; b=XEysFft3nMmn8gOMlPbDVsji1VljkHd/pS5m+6wB5NSOF86Wt3uin6HkdONoKMd8qm9wD3UUzCqjIxzmMSTafzxrGZykWM/dugUWyHdR6g/nsvgJlF/2jY/d2fmdjUO+vU+QAXiskIM0QR9G4WbHX8wz1jgmZoxV2j/c5waf9FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723693591; c=relaxed/simple;
	bh=kPGwFclQIvtXy7MuavVzMMSi6JvaAH/hja/wgOwZdhY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=px12dssJlUhJ/2enhPwR82p9tV2t/W5af5w0eZr9EmBQWf49Gd0kKsh5sqJp8j28ECBmHO28CIALTG0Z7IkYaTh0k3C5RsvPZB62AicRutEth6WiIvMvD5YApBPhAjL9qX0wj3feJ03WrlLFmkliWJWbIDffF6BlobUgeuEKXlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BBTlxu0f; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BBTlxu0f"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-530d0882370so468098e87.3
        for <linux-cifs@vger.kernel.org>; Wed, 14 Aug 2024 20:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723693588; x=1724298388; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dR0E44D16CNR/7n2bVck4hf3eeDt0OXsN8Plq8P7udk=;
        b=BBTlxu0fj1YmrrwlFkZ7zA3p/t/zFq3AAtgqjUubHldC07rr6onIfKRSDZnaFHAxha
         PkDf1WZfe2UNcqsgIcEWxcJMyISMg15I48ADu1xIMDdJMVoUB6+WSC5Mp6L4uClEolPf
         PnmlRtL6sasfB9xDS/K+qrzB9shNuukdwzibrLkoR5L0rXgIgYGVuf+jTCa3qxSpvhah
         rKJm2b/bqYSEd8FenCj2SofHoHvw2czr0gytk7IIBkdyDyug3G2I8dwcCkA2h6MusMKH
         B7490mf3djCbyDg0hKwMuzc971eilZgOjot5Z+Pcry9kjrdo7cCnILuJvKMvFZNJyrr8
         jUfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723693588; x=1724298388;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dR0E44D16CNR/7n2bVck4hf3eeDt0OXsN8Plq8P7udk=;
        b=jIznbB1vA5jakyagC8dodPwcfMasAPkCUYoMafH2vxaLNl87cnkdsoWsN9TJVRrJ6O
         5HIyam/Nvwjn/bXLJ3dti1COsLEn7nfkHB8lxofk3pTKpnncRZnVyGenw68Vv4NQUvOb
         jCvIU37eLsG2RT5FtjVs3UHili0gOPO5R8dQr8DepLSNOYATCtOjsiRIwl1CUgeGRRZN
         68/Cl6YUoaoRNg0P5KeqAY7SAeIOL2Bx8CxaFO3yBI3TQR/yKGIyvcI6y6TabYYP/ady
         Pk87niIS2MYc0GpwudVfePosWA5kcmIaP93587wFkm4YZRgSZmMZq90zj/NV7SwDrbyb
         PxQg==
X-Forwarded-Encrypted: i=1; AJvYcCVt4rdF1p9YgGUJWh6S44m/UnmmOUhz5n73yeEKp8nGAs/w58yKQVW85bd7nYQcweX55m8oXgpJc/GDvLlDEKIXBLymk5cdb9AaPw==
X-Gm-Message-State: AOJu0YxfxYBaXxQyOzX/KRPkai4YOSd2VzpUbhSh24PmEKynQCEEw4IV
	4XdT+QyLwGhpjxcCXaktHtT+jg7s5BxUdl+xVmCBNgMPmJO4+Mnr/fLFTr2TI3GDM8erT9i1mUR
	b6o6olrQk2WFG6N9SGr2zy5ZlZ4LD5Vp0
X-Google-Smtp-Source: AGHT+IEW2SFVNYDn6XU+DFuDlo2rSnASqPiKMPZkL5bn/MbkO7KlOSE+RisWwGYJQ6mInJ3rb1+GTYpfMrrbSoJ2Kck=
X-Received: by 2002:a05:6512:1310:b0:52d:b226:9428 with SMTP id
 2adb3069b0e04-532eda8e621mr3579303e87.6.1723693587364; Wed, 14 Aug 2024
 20:46:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 14 Aug 2024 22:46:15 -0500
Message-ID: <CAH2r5msXPLo5KDNTK6N5WUcytqf93BO4PKiFMQ0RYS3BLt0aBg@mail.gmail.com>
Subject: incorrect lock checks in cifs_writev()
To: Paulo Alcantara <pc@manguebit.com>, Shyam Prasad N <nspmangalore@gmail.com>, 
	Bharath S M <bharathsm@microsoft.com>, David Howells <dhowells@redhat.com>, 
	CIFS <linux-cifs@vger.kernel.org>
Cc: Andrew Bartlett <abartlet@samba.org>
Content-Type: multipart/mixed; boundary="000000000000fa2bf5061fb0afa1"

--000000000000fa2bf5061fb0afa1
Content-Type: text/plain; charset="UTF-8"

In file.c we are checking for Windows style lock conflicts (even
though this is Linux) for cached i/o which seems wrong (unless user
mouns with "forcemandatorylock" which today is ignored for non-POSIX
mounts)

One obvious way to fix this would be to do something like this change:

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 45459af5044d..a6c97af31cdf 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2789,9 +2789,6 @@ cifs_strict_writev(struct kiocb *iocb, struct
iov_iter *from)
        struct inode *inode = file_inode(iocb->ki_filp);
        struct cifsInodeInfo *cinode = CIFS_I(inode);
        struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-       struct cifsFileInfo *cfile = (struct cifsFileInfo *)
-                                               iocb->ki_filp->private_data;
-       struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
        ssize_t written;

        written = cifs_get_writer(cinode);
@@ -2799,9 +2796,7 @@ cifs_strict_writev(struct kiocb *iocb, struct
iov_iter *from)
                return written;

        if (CIFS_CACHE_WRITE(cinode)) {
-               if (cap_unix(tcon->ses) &&
-                   (CIFS_UNIX_FCNTL_CAP &
le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-                   ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0)) {
+                   if ((cifs_sb->mnt_cifs_flags &
CIFS_MOUNT_NOPOSIXBRL) == 0) {
                        written = netfs_file_write_iter(iocb, from);
                        goto out;
                }


Another would be something like:
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 45459af5044d..57f9d934eb4e 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2753,6 +2753,7 @@ cifs_writev(struct kiocb *iocb, struct iov_iter *from)
        struct inode *inode = file->f_mapping->host;
        struct cifsInodeInfo *cinode = CIFS_I(inode);
        struct TCP_Server_Info *server = tlink_tcon(cfile->tlink)->ses->server;
+       struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
        ssize_t rc;

        rc = netfs_start_io_write(inode);
@@ -2769,12 +2770,16 @@ cifs_writev(struct kiocb *iocb, struct iov_iter *from)
        if (rc <= 0)
                goto out;

-       if (!cifs_find_lock_conflict(cfile, iocb->ki_pos, iov_iter_count(from),
+       if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL))
+               if (cifs_find_lock_conflict(cfile, iocb->ki_pos,
iov_iter_count(from),
                                     server->vals->exclusive_lock_type, 0,
-                                    NULL, CIFS_WRITE_OP))
-               rc = netfs_buffered_write_iter_locked(iocb, from, NULL);
-       else
-               rc = -EACCES;
+                                    NULL, CIFS_WRITE_OP)) {
+                       rc = -EACCES;
+                       goto out;
+               }
+
+       rc = netfs_buffered_write_iter_locked(iocb, from, NULL);
+
 out:
        up_read(&cinode->lock_sem);
        netfs_end_io_write(inode);


Any opinions about which approach looks better?

-- 
Thanks,

Steve

--000000000000fa2bf5061fb0afa1
Content-Type: text/x-patch; charset="US-ASCII"; name="WIP-lock-conflict-fix.diff"
Content-Disposition: attachment; filename="WIP-lock-conflict-fix.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_lzuqk6380>
X-Attachment-Id: f_lzuqk6380

ZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvZmlsZS5jIGIvZnMvc21iL2NsaWVudC9maWxlLmMK
aW5kZXggNDU0NTlhZjUwNDRkLi5hNmM5N2FmMzFjZGYgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGll
bnQvZmlsZS5jCisrKyBiL2ZzL3NtYi9jbGllbnQvZmlsZS5jCkBAIC0yNzg5LDkgKzI3ODksNiBA
QCBjaWZzX3N0cmljdF93cml0ZXYoc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3QgaW92X2l0ZXIg
KmZyb20pCiAJc3RydWN0IGlub2RlICppbm9kZSA9IGZpbGVfaW5vZGUoaW9jYi0+a2lfZmlscCk7
CiAJc3RydWN0IGNpZnNJbm9kZUluZm8gKmNpbm9kZSA9IENJRlNfSShpbm9kZSk7CiAJc3RydWN0
IGNpZnNfc2JfaW5mbyAqY2lmc19zYiA9IENJRlNfU0IoaW5vZGUtPmlfc2IpOwotCXN0cnVjdCBj
aWZzRmlsZUluZm8gKmNmaWxlID0gKHN0cnVjdCBjaWZzRmlsZUluZm8gKikKLQkJCQkJCWlvY2It
PmtpX2ZpbHAtPnByaXZhdGVfZGF0YTsKLQlzdHJ1Y3QgY2lmc190Y29uICp0Y29uID0gdGxpbmtf
dGNvbihjZmlsZS0+dGxpbmspOwogCXNzaXplX3Qgd3JpdHRlbjsKIAogCXdyaXR0ZW4gPSBjaWZz
X2dldF93cml0ZXIoY2lub2RlKTsKQEAgLTI3OTksOSArMjc5Niw3IEBAIGNpZnNfc3RyaWN0X3dy
aXRldihzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBpb3ZfaXRlciAqZnJvbSkKIAkJcmV0dXJu
IHdyaXR0ZW47CiAKIAlpZiAoQ0lGU19DQUNIRV9XUklURShjaW5vZGUpKSB7Ci0JCWlmIChjYXBf
dW5peCh0Y29uLT5zZXMpICYmCi0JCSAgICAoQ0lGU19VTklYX0ZDTlRMX0NBUCAmIGxlNjRfdG9f
Y3B1KHRjb24tPmZzVW5peEluZm8uQ2FwYWJpbGl0eSkpICYmCi0JCSAgICAoKGNpZnNfc2ItPm1u
dF9jaWZzX2ZsYWdzICYgQ0lGU19NT1VOVF9OT1BPU0lYQlJMKSA9PSAwKSkgeworCQkgICAgaWYg
KChjaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIENJRlNfTU9VTlRfTk9QT1NJWEJSTCkgPT0gMCkg
ewogCQkJd3JpdHRlbiA9IG5ldGZzX2ZpbGVfd3JpdGVfaXRlcihpb2NiLCBmcm9tKTsKIAkJCWdv
dG8gb3V0OwogCQl9Cg==
--000000000000fa2bf5061fb0afa1
Content-Type: text/x-patch; charset="US-ASCII"; name="WIP-alternative-lock-conflict-fix.diff"
Content-Disposition: attachment; 
	filename="WIP-alternative-lock-conflict-fix.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_lzuqmcmm1>
X-Attachment-Id: f_lzuqmcmm1

ZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvZmlsZS5jIGIvZnMvc21iL2NsaWVudC9maWxlLmMK
aW5kZXggNDU0NTlhZjUwNDRkLi41N2Y5ZDkzNGViNGUgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGll
bnQvZmlsZS5jCisrKyBiL2ZzL3NtYi9jbGllbnQvZmlsZS5jCkBAIC0yNzUzLDYgKzI3NTMsNyBA
QCBjaWZzX3dyaXRldihzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBpb3ZfaXRlciAqZnJvbSkK
IAlzdHJ1Y3QgaW5vZGUgKmlub2RlID0gZmlsZS0+Zl9tYXBwaW5nLT5ob3N0OwogCXN0cnVjdCBj
aWZzSW5vZGVJbmZvICpjaW5vZGUgPSBDSUZTX0koaW5vZGUpOwogCXN0cnVjdCBUQ1BfU2VydmVy
X0luZm8gKnNlcnZlciA9IHRsaW5rX3Rjb24oY2ZpbGUtPnRsaW5rKS0+c2VzLT5zZXJ2ZXI7CisJ
c3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiA9IENJRlNfU0IoaW5vZGUtPmlfc2IpOwogCXNz
aXplX3QgcmM7CiAKIAlyYyA9IG5ldGZzX3N0YXJ0X2lvX3dyaXRlKGlub2RlKTsKQEAgLTI3Njks
MTIgKzI3NzAsMTYgQEAgY2lmc193cml0ZXYoc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3QgaW92
X2l0ZXIgKmZyb20pCiAJaWYgKHJjIDw9IDApCiAJCWdvdG8gb3V0OwogCi0JaWYgKCFjaWZzX2Zp
bmRfbG9ja19jb25mbGljdChjZmlsZSwgaW9jYi0+a2lfcG9zLCBpb3ZfaXRlcl9jb3VudChmcm9t
KSwKKwlpZiAoKGNpZnNfc2ItPm1udF9jaWZzX2ZsYWdzICYgQ0lGU19NT1VOVF9OT1BPU0lYQlJM
KSkKKwkJaWYgKGNpZnNfZmluZF9sb2NrX2NvbmZsaWN0KGNmaWxlLCBpb2NiLT5raV9wb3MsIGlv
dl9pdGVyX2NvdW50KGZyb20pLAogCQkJCSAgICAgc2VydmVyLT52YWxzLT5leGNsdXNpdmVfbG9j
a190eXBlLCAwLAotCQkJCSAgICAgTlVMTCwgQ0lGU19XUklURV9PUCkpCi0JCXJjID0gbmV0ZnNf
YnVmZmVyZWRfd3JpdGVfaXRlcl9sb2NrZWQoaW9jYiwgZnJvbSwgTlVMTCk7Ci0JZWxzZQotCQly
YyA9IC1FQUNDRVM7CisJCQkJICAgICBOVUxMLCBDSUZTX1dSSVRFX09QKSkgeworCQkJcmMgPSAt
RUFDQ0VTOworCQkJZ290byBvdXQ7CisJCX0KKworCXJjID0gbmV0ZnNfYnVmZmVyZWRfd3JpdGVf
aXRlcl9sb2NrZWQoaW9jYiwgZnJvbSwgTlVMTCk7CisKIG91dDoKIAl1cF9yZWFkKCZjaW5vZGUt
PmxvY2tfc2VtKTsKIAluZXRmc19lbmRfaW9fd3JpdGUoaW5vZGUpOwo=
--000000000000fa2bf5061fb0afa1--
