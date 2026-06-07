Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5E7223DE9
	for <linux-cifs@vger.kernel.org>; Sun,  7 Jun 2026 16:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780850303; cv=pass; b=CD/b/zxIwaRtd0i+O6B/9gLBLwIgH1ipK7K0OiDds1QghtIx7Fx8TKpMD2UUvaYUvGTCL4OM+cjWPnwJFDJY0oeaLAvzz/T5IAgTG50kOfp63fffHPtyqZCuJ/Auk6aSUi+sdBFy0rvf4q+d2Xwq8U+eI40IWGjErefa91ToOp0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780850303; c=relaxed/simple;
	bh=eR2w6B4YjoXAyPTGTvnmtxI4r/i8PZykqAkLOWt6Ydg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VAtYywjd3WtWM6jRP68d35r3FcVbulYFdlRttSOfSJaxGpAJotzkjszZpry4b8d0oh5duhoJUp2vFQ8u4XKyFLsRq76klWNpj7Wx4/hyZmVD1h4Uk5JKq7Srs67qop6JE3U8FCQ3B9YXJbHVIGvWVMbSFHclakVqLfefDzYFMsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EmblLhSi; arc=pass smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EmblLhSi"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-9157b895c57so327192985a.3
        for <linux-cifs@vger.kernel.org>; Sun, 07 Jun 2026 09:38:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780850301; cv=none;
        d=google.com; s=arc-20240605;
        b=MgnLkXV5zGg938aJfuG7XawMnNCC8FfLId5d+RGVz6EKfk0DDMzLyWukp7wz5WCHpC
         IBnU+GM7LWQGR9i4vFWps8x+Tp1tyln2T0SVrbfMrv1M2DGO1CiYoobZdiJ4LSXPRvqR
         SIDBG1MyhV5h7835xYBlDR5FoM5hhGZ8q0uN5pjBffunB33Mu0nJ6njPfSmzYys28pKd
         FtVonV/3EPjswQdCbu+F6KAZR2TbCvkIGGQDFZMxGcaOtxR4W/IGs7O7c58jNHSdDVkY
         +HUOkZO71OgKC0k699UdIeTmlwEP1AGid5SaiZgtTeYJX1TcdAlzwBRLPGCiyrLiQMWd
         2RuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QnQJ49HuUxMtCpZFirO0rfc2/kiCz6vZG4WfqZejSys=;
        fh=AIUtT+8WGybXWGu2ZZT5Ey3UVF08ZfL0OEB0oUIBb1Y=;
        b=d6Jaz9KLOJAlMjO7pEnuAAyQ8nGmZZTG36kPuJr5nbpKsC6ahtoXMzYVW4d+pFlPTP
         XjNf92eLbjYsAcNgEk0whUZyjGPBhTepuySunx5RtzfmhAETvAdMEZzx77/ON6Jyny5y
         pxkdt6FY1qyB2id8uDm+vSGPdix5Al9LVLIQ9O1KAYGMNwRIXGtOPzjq36n0drBus5CM
         v2G0xs05H9+Rw+9Dm6uRHlUBA4rRDhcxSiZHrKnTA1WxLpKbws07KHosbF2q88/OSyE8
         lgS3z1UeEMoU3ApZvNWhMUyNE4VLCx4xpeWjSle6qlKecbRsydi8pd6ap2HqHjqv+FHZ
         q5yQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780850301; x=1781455101; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QnQJ49HuUxMtCpZFirO0rfc2/kiCz6vZG4WfqZejSys=;
        b=EmblLhSi4x4BDIiW5i1BvONsQBglVKiL3MKApuzHbJlQ1Z+mmXHLfwYJn7wnYRZRNB
         Ma9TA+iRXUsXW8DGxRORGXEj3G0zqx010nJxxTyuByoq3vkLkbo0Qz9cG4c2seJxOsf5
         BBQ2t6/rKktkO5Vgv5tDV+pYeqxCmpEiq7GUbbEXKHVifc0qZDVKfINGqIrIIasse5K9
         2XFDUxVa1Meu8jjwxnnH/fLf83NjIU4EL8GTeY13XleNXgPu1nkoIHMuIu/jXkuTY59x
         j4UzvgNZvrDKEBRP/VBUKQhwXMqHiT4vyu/67Ubqc+JYWqDizd2jOqLGknU53pz8kHrG
         CksQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780850301; x=1781455101;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QnQJ49HuUxMtCpZFirO0rfc2/kiCz6vZG4WfqZejSys=;
        b=op+ahN5DpSyRWC67iXK+1Sag5RviRZMY9eYWGsxCfBs3+5l/DSSM1bWdireuqzqO7h
         cuX+XxMZaZHSDGq56kHyXxaDvX/7j2Qlp4lGXVMjfB0TyFtqsKEgpIDvnjTLkTCTGo2m
         PW+7pEpNAPdqOmJHZH5xfGoRwG8erE1VslsX/i2mmce42mFxKDK49zhtJHzA3Z9W2qmc
         rn5ZC5nFSmHc0lVvlXHcq7sFcTDmI/gcV7UCl3KwhavnPtppjzTqJZPxE3UFaWQGbq0u
         Mh9sADboKT+iALdSLDQowpmYZ5GIfXi2eqNoKVmSnuWQPiLiGVYIPHcjdDt9FHGUSPj9
         ZcBg==
X-Forwarded-Encrypted: i=1; AFNElJ9KyAz6VBvvSRbUxr1Cjj2M3NeopDx8qHZPfYQetJ70ihUsJdG/cvZjdnAjsixQAVtSbblLAqMmdi6n@vger.kernel.org
X-Gm-Message-State: AOJu0YzoLz7SyuTFA4BZLq8/AMZ6K6E12fgqriaGgkA0R9STN1GeUGHu
	4+lRFaK2/iNN3AJymmA/A08K7QDpkomU2u4BgQ52emGBjdWTQWCYhZFGK7W4VdOMQ7lPF1p8XsR
	9aeqNGE8pwWnH7E0esRNI1paL11v0mLE=
X-Gm-Gg: Acq92OHfQmg7Q9TCJr7YEWFOTDgzLSt81F+nnXSJjJTAqElt/zstXDtr9wQDTJlof8c
	eFuwi2OJLjka8vggM+hZdq67pShLovNeQDV7GadwtI5vjCehT8pvE2nngC3W/VzMxq7QFcijdIq
	pSEfCDbjJg3nYi77yJy0wyVEh1MzJthxJmglIVWqBmfaCoO0HnkeDcOB/fRoLHFMmWuifW9CL77
	4yPdOz+ZPhXM1eIvm88CWnkeAPrGt7Ghs+XO6A1CP/qFzYdEZevRxmCfXsRk/JrwnwQ1EZRh3x4
	OpraEdqhtbDRxkz+6CAsR0UlERM0RC4gSWXK1aB7sxAEKePrg6yotl0/xBD1dKuvrjwmmD9i00c
	IsAoBp3hxtR1ypp5ox0Akr3rc+l2Dhs7AeYIU3TyYc/QWL7ki921jtKpsL5isg4YDhu3x8HtSll
	KZeYawploFSY+2kLtiLQcMFYmidGKe
X-Received: by 2002:a05:620a:25c8:b0:915:9125:e65a with SMTP id
 af79cd13be357-915a9dc0519mr1899334385a.43.1780850301178; Sun, 07 Jun 2026
 09:38:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mv_wgjBqEsWYGxEt86tN6hJNV1VBY2YipAbeP8goxsSZA@mail.gmail.com>
 <1aa393be-4f17-4dc4-989d-77b0dc6de09d@samba.org> <01a5f813-1847-4ede-83a5-62bef4dd26ed@samba.org>
In-Reply-To: <01a5f813-1847-4ede-83a5-62bef4dd26ed@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 7 Jun 2026 11:38:09 -0500
X-Gm-Features: AVVi8CcFE2ksXC6nTs60-mgNKoJAEJFz5PeGqoLz5IaRtgVPzf7yUpF-z-YmiNI
Message-ID: <CAH2r5mubw0zVBO83XzOmhWSOzq6PM5OkP-18Eg+LK3tvoULzkQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix chmod and chgrp with SMB3.1.1 POSIX Extensions
To: Ralph Boehme <slow@samba.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Jeremy Allison <jrasamba@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> For chmod() SMB3-POSIX *does* tell you to use S-1-5-88-3-<mode>, so
*if* we want some SID encoding of uids/gids, we should use S-1-5-88

We definitely have use cases where the client (similar to what you see
with people using nfs on Linux) wants to be able to save and view
uids/gids that the client understands without worrying about whether
server has RFC2307 setup to map uids.  The server may not have those
same users defined locally but the server still saves the uids and
gids (similar to nfs).

One advantage of having two uid mapping choices (S-1-5-88-x vs
S-1-22-x) is that it would allow you to have two different server
behaviors (one where the client changing the uid also changes the
server uid for the file, and the other where changing the client uid
is stored by the server but doesn't update the uid on the local file).

Do you have a change to Samba server fixing the chmod bug with
modefromsid?  I see that creating a file the mode is set incorrectly,
and that chmod doesn't work either (it briefly works while the lease
is on the file, but when the lease expires, requerying from the server
you can see the mode hasn't changed).

root@smfrench-ThinkPad-P16s-Gen-2:/mnt/scratch# touch file
root@smfrench-ThinkPad-P16s-Gen-2:/mnt/scratch# ls -l file
-rwxrw-rwT 1 root root 0 Jun  7 11:34 file
root@smfrench-ThinkPad-P16s-Gen-2:/mnt/scratch# ls -l /home/scratch/file
-rwxrw-rw-+ 1 root root 0 Jun  7 11:34 /home/scratch/file
root@smfrench-ThinkPad-P16s-Gen-2:/mnt/scratch# chmod 0760 file
root@smfrench-ThinkPad-P16s-Gen-2:/mnt/scratch# ls -l /home/scratch/file
-rwxrw-rw-+ 1 root root 0 Jun  7 11:34 /home/scratch/file
root@smfrench-ThinkPad-P16s-Gen-2:/mnt/scratch# ls -l file
-rwxrw---- 1 root root 0 Jun  7 11:34 file
root@smfrench-ThinkPad-P16s-Gen-2:/mnt/scratch# ls -l file
-rwxrw-rwT 1 root root 0 Jun  7 11:34 file

On Sun, Jun 7, 2026 at 9:40=E2=80=AFAM Ralph Boehme <slow@samba.org> wrote:
>
> Hi Steve,
>
> I spend some more time looking into this. Some findings:
>
> * We don't have any kind of design if and how uids/gids could be encoded
> as S-1-22-x (Samba style) or S-1-5-88-x (MS NFS style) in SMB3 POSIX.
>
> * For chmod() SMB3-POSIX *does* tell you to use S-1-5-88-3-<mode>, so
> *if* we want some SID encoding of uids/gids, we should use S-1-5-88.
>
> * cifs.ko supports both S-1-22 and S-1-5-88 when querying metadata and
> mapping to uid/gid. I tested both versions with a modified Samba server
> that allowed me to configure which SIDs to return (S-1-5-domain, S-1-22
> or S-1-5-88)
>
> * To fix chown() for SMB3 POSIX, all we need is the second hunk from
> your patch, cf attached patchset, first commit. By default this will
> only work with cifs.idmap setup and use "normal" "domain-SIDs".
>
> * If the user is working with a setup where idsfromsid is being used (so
> identities are mapped to and from S-1-5-88-x), the user mounts with
> "posix,idsfromsid" and the existing chown() code will correctly encode
> the mode as an S-1-5-88-3-<mode> ACE.
>
> * @namjae: ksmbd wrongly switched from S-1-5-88-x to S-1-22-x in
> 5609bdd9ffdccd83f9003511b1801584b703baa5.
>
> * @namjae: ksmbd returns the wrong SID for the owner in the
> SMB2_POSIX_CREATE_CONTEXT:
>
> Chain Element: SMB2_POSIX_CREATE_CONTEXT
> "5025ad93-b49c-e711-b423-83de968bcd7c"
>      Data: POSIX Create Context response
>          Number of Links: 1
>          Reparse Tag: Unknown (0x00000007)
>          POSIX perms: 0604
>          Owner SID: S-1-5-21-2305724116-1275954598-2605249026-1000
>          Group SID: S-1-22-2-1000
>
> It maps the gid to the S-1-22 domain but returns the uid mapped to the
> local domain from /etc/ksmbd/ksmbd.subauth.
>
> * What's still missing imo is a protocol spec to negotiate use of
> S-1-5-88-x identity mapping. We could define a new create context that
> allows the client to request it. If the server supports it, it returns
> the context. The client then only uses the mapping if the server
> signalled support. For Samba this might be quite some work particularily
> in the ACL code, not so much for owner and group.
>
> -slow



--=20
Thanks,

Steve
