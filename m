Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B3525D538
	for <linux-cifs@vger.kernel.org>; Mon,  5 May 2025 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746457520; cv=none; b=Zpl/ehHTOxhnWKhvrMqiIE008OG99tDd11IRqECW/ecMx0mc+U9x9hEbd8gictl1LWdlREse7EjEFiKLGLE7Q+hwz880otk8lM4ATFsrq3pULjgsPLq59s6Hc0+yU8eentk+dZtrTs3CsZgrEc0SB4YxJ8NT0t2N81JvQHYv9XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746457520; c=relaxed/simple;
	bh=t9e80FNnv6gAAXaxNaizo4h4iLcZXQgfY1sMHZDH+4Y=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=CY89nWnYjaBZZsAaXXm8/CL+ImZmTEKOnQ1sF9STEhVwTovvpskwbvwEHWuTk+wW9Vx655Wik2uVxYdMPVJIZqhdfPGv0+Vnl6YIaJL/LfXemOtckxLjGmEeEtKeWBESFj8R7nmLTeKYLjDhi/9mYy0FOEGhu7S2+ELenwpB8T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=DIMwVK+m; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="DIMwVK+m"
Message-ID: <c9015c6037df3dd50be1b20c0f0ac04d@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1746457514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8zEvBFGkBSipiwjpo/mLITgE8OMyY/hLiNEWCdxwf2g=;
	b=DIMwVK+mbf2gOPj3aMMkYFiT1cIbX7u47BzlwelrCg26Xy+TzVRqVqWp14m/O9axM1BNRW
	e3vpg+yqxZAQj8aiLj1vFtfNb9FusvF7LH3QhyTAU1CDXyAaymd24SchhDlvcJpU755JG2
	xfRuprDwku0Js54vh0BTYOZEoOjY4Igw16ItwP3S7AyPAps7DGdKBa+QJSwuXktGd5U0hE
	dE5tp8bI7aS50NlUMYcrDZPV+Ot7JNElh3DMim7fvXh33dNfBXCm8u1VFvPqzCdUwD+MQK
	lBGZa9kcXHc5fGE34LSlkYiqiLXHcLsMNlqq41SDqW3E4I7lvGSRwGBrfn1k8g==
From: Paulo Alcantara <pc@manguebit.com>
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org, David
 Howells <dhowells@redhat.com>, Pierguido Lambri <plambri@redhat.com>,
 Bharath S M <bharathsm@microsoft.com>
Subject: Re: [PATCH] smb: client: fix delay on concurrent opens
In-Reply-To: <CAGypqWxSgsR9WFB6q4_AbACXeDKGiNrNdbVzGms2d9fc2nfspQ@mail.gmail.com>
References: <20250428140500.1462107-1-pc@manguebit.com>
 <CAH2r5muGNUp9UqQZ_mPVoLiw9+xocV8OZ8hubGyQG=oTd=-BXQ@mail.gmail.com>
 <2f76f9b0b3e5ca99fce360d19b0d6218@manguebit.com>
 <CAGypqWx0xEJRD_7kxNAiyLB5ueSGFda1bkRXECXtUhinVgvV-A@mail.gmail.com>
 <3d7d41c055cd314342ec1f33e6332c32@manguebit.com>
 <CAGypqWxSgsR9WFB6q4_AbACXeDKGiNrNdbVzGms2d9fc2nfspQ@mail.gmail.com>
Date: Mon, 05 May 2025 12:05:09 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Bharath,

Bharath SM <bharathsm.hsk@gmail.com> writes:

> On Mon, May 5, 2025 at 6:42=E2=80=AFPM Paulo Alcantara <pc@manguebit.com>=
 wrote:
>>
>> Bharath SM <bharathsm.hsk@gmail.com> writes:
>>
>> > If the file has only deferred handles and a handle lease break occurs,
>> > closing all the handles triggers an implicit acknowledgment. After the
>> > last handle is closed, the server may release the structures
>> > associated with the file handle. If the acknowledgment is sent after
>> > closing all the handles, the server may ignore it or it may return an
>> > invalid file error, as it could have already freed the handle/lease
>> > key and related structures.
>>
>> I couldn't find anything in the specs related to the above.  Could you
>> please point me out to the correct specs or is this just theorical?
>
> Sorry for confusion, this is not from spec. I was trying to say, if we
> remove the check
>  "&& !list_empty(&cinode->openFileList" in code then client may get
> "STATUS_OBJECT_NAME_NOT_FOUND" error when client sends lease break ack af=
ter
> closing all file handles. Attached the pcap for ref.

Ah, thanks for the explanation!  Yes, that's indeed a problem.  We
should be calling _cifsFileInfo_put() right after sending the lease
break ack, as the old code did.

>> Have you been able to reproduce the above?  If so, please share the
>> details.
>
> Yes, attached the wireshark capture. please take a look.
> steps:
> 1) Build cifs.ko by removing  "&& !list_empty(&cinode->openFileList)"
> in cifs_oplock_break
> 2) Mount file share with "nosharesock,closetimeo=3D30" at /mnt/test1 and
> /mnt/test2 ...
> 3) cd  /mnt/test1; echo "aaa" >> testfile
> 4) On other shell, cd /mnt/test2; echo "aaa" >> testfile
>
>> If the server is returning an invalid file error for a lease break ack
>> sent by the client that should be a no-op, isn't that a server bug then?
>
> Windows Server returns STATUS_OBJECT_NAME_NOT_FOUND error code in such ca=
ses.
> But I am not sure if this is a server bug.

That's a legitimate error.  See above.

>> > Additionally, this would result in an extra command being sent to the
>> > server. This check was added to avoid this case to send lease break
>> > ack only when openfilelist is not empty.
>>
>> I understand.  The problem with attempting to save that extra roundtrip
>> has caused performance problems with our customers accessing their
>> Windows Server SMB shares.
>
> I agree that we need to fix the customer issue on priority, but just
> pointing out that when
> we remove the existing check we will end up with this behavior. But if
> we can reproduce
> the cx issue or scenario then may be able to find a better fix which
> can handle both cases.?
>
> Please let me know your comments.

Unfortunately I don't have any reproducers for the customer issue.

With these changes I no longer get the STATUS_OBJECT_NAME_NOT_FOUND
error with your reproducer.  Let me know.

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 851b74f557c1..5facc85b408a 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3083,11 +3083,10 @@ void cifs_oplock_break(struct work_struct *work)
 	struct cifsInodeInfo *cinode =3D CIFS_I(inode);
 	struct cifs_tcon *tcon;
 	struct TCP_Server_Info *server;
+	bool purge_cache =3D false;
 	struct tcon_link *tlink;
+	struct cifs_fid *fid;
 	int rc =3D 0;
-	bool purge_cache =3D false, oplock_break_cancelled;
-	__u64 persistent_fid, volatile_fid;
-	__u16 net_fid;
=20
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
 			TASK_UNINTERRUPTIBLE);
@@ -3134,32 +3133,21 @@ void cifs_oplock_break(struct work_struct *work)
 	 * file handles but cached, then schedule deferred close immediately.
 	 * So, new open will not use cached handle.
 	 */
-
 	if (!CIFS_CACHE_HANDLE(cinode) && !list_empty(&cinode->deferred_closes))
 		cifs_close_deferred_file(cinode);
=20
-	persistent_fid =3D cfile->fid.persistent_fid;
-	volatile_fid =3D cfile->fid.volatile_fid;
-	net_fid =3D cfile->fid.netfid;
-	oplock_break_cancelled =3D cfile->oplock_break_cancelled;
-
-	_cifsFileInfo_put(cfile, false /* do not wait for ourself */, false);
-	/*
-	 * MS-SMB2 3.2.5.19.1 and 3.2.5.19.2 (and MS-CIFS 3.2.5.42) do not require
-	 * an acknowledgment to be sent when the file has already been closed.
-	 */
-	spin_lock(&cinode->open_file_lock);
-	/* check list empty since can race with kill_sb calling tree disconnect */
-	if (!oplock_break_cancelled && !list_empty(&cinode->openFileList)) {
-		spin_unlock(&cinode->open_file_lock);
-		rc =3D server->ops->oplock_response(tcon, persistent_fid,
-						  volatile_fid, net_fid, cinode);
+	fid =3D &cfile->fid;
+	/* MS-SMB2 3.2.5.19.1 and 3.2.5.19.2 (and MS-CIFS 3.2.5.42) */
+	if (!cfile->oplock_break_cancelled) {
+		rc =3D server->ops->oplock_response(tcon, fid->persistent_fid,
+						  fid->volatile_fid,
+						  fid->netfid, cinode);
 		cifs_dbg(FYI, "Oplock release rc =3D %d\n", rc);
-	} else
-		spin_unlock(&cinode->open_file_lock);
+	}
=20
 	cifs_put_tlink(tlink);
 out:
+	_cifsFileInfo_put(cfile, false /* do not wait for ourself */, false);
 	cifs_done_oplock_break(cinode);
 }
