Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A042EAB82
	for <linux-cifs@vger.kernel.org>; Sun,  3 May 2026 15:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777821867; cv=pass; b=Da6T2tCvIuLddofhPD1xTcnXXWvxNt2HmVQVZz1jBb//desLV9bF2YAEcXdtRdH6oOz0/KFRtpbmHoTkq1nf6pVHdONhytz5z/zSR/dmuwAJ/5U0tBjQf4rM8oqAprXNr1DqirqWewFYTWSpsYIP+aW++FIOvDJpL+5P/uMgSWc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777821867; c=relaxed/simple;
	bh=qErxFlaQsMJljN65R/Za1i2arUaAHxn36XGOWaQZ+XI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GrZZ8Hsr5fmnPYcTw/eCZ413exXNsBYVPxh2+pXqOpKsIwos9RaRzeZfdD7Hp+5fa6X2cBx8Sq2An9PCNIOvlAGlB0IURjUdxUbnduZgPZm06hdolk3z1/A7dbumQ8WCXXyHg7LIBGjYuNoSxOvpimEnJeWETrhbwJtvF3/Mzig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=swG1EO4J; arc=pass smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="swG1EO4J"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-899a5db525cso22828326d6.3
        for <linux-cifs@vger.kernel.org>; Sun, 03 May 2026 08:24:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777821864; cv=none;
        d=google.com; s=arc-20240605;
        b=QupyhlDxDePAJS7u76luhpeCfwE5zlC7MaiN8NQm9ctKbrRLOQtZYouaqSQqlQr5zg
         ItzE1DmIi3OxDrwMUwyDZNixu0XtvZyHnbNyEIjR44ASNhvl0+S+CWgN/r26iaxYG/gk
         9f82yxIRrkgYVOaS1c5GkawMcXWADdaZV/DRMon8BuHQXXUCKe4Jkh/YXwOX+KuDZWaP
         im/zynIv0moEKV11OXHgHEU/GJTfcdWn/tCNiC7XsPn3imf928JTnuJQQHvys+hir7Sq
         Xy8akiAC3I4C57uEQbJjvmASlTkwjFnOvzBpLH+LdBviYt1cQWqDgX3nWm6YBapSTc1V
         pvKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dk44ltyjNXeb94AL68tKtmcqm1AiCDfhD8eU6ZDxGXM=;
        fh=FeD1LK0eWMWCTaKqdLpyyQ4Fx7OwVxgpeJgyMTx1RDI=;
        b=J0OrS6uHIBncMxfgggoHe3EM4z+hTblZqkHgWKM2p2bB3bBXF6X1gThGcOhMpB3uU9
         /Qm6L3qdY0tl8OcJ7lu8argNu+tbONkBPvwHvOsUrTHbQL67uSzBouSVKXAgWVGxRBQi
         O56asGL7D/k/TZDboExbDBs9LxF+CkuOXdZC6fNHKOTRoboQrv7gAsm6nZOY549GlG+p
         pgVovgFqp3JjteqmoJh5QVMCjSD7ivvjtBizipa2SAMpm6AhP9zz8fiaGD4zSD7BQyzO
         nk+m378urA4s9rOLVpyiNLsDqHck553xxIZAN18FbGMu19cTwrjV2Nk0houmgZBdQ/2f
         bcxw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777821864; x=1778426664; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dk44ltyjNXeb94AL68tKtmcqm1AiCDfhD8eU6ZDxGXM=;
        b=swG1EO4JtKGflB1Wie5G+9wUlJ4nDmm00FzWVCnr90nmDVI9/NLqPT4TwbRNxNqb8V
         JmEVvxMmtDCkU/j1qsfmF/G9qkXiC4wTP6ep/jpRJ1ot227djzu72zmqbYemo+5zFXOP
         hi1WxQQV7gJ4619lSSPeETwRUxD9YhAA7RQC4W7D5kARQ7dkG/azDkKJfzmoqG+Q9wMZ
         FYbe9MVCvd/SBm9vSRKrVwaeDbHqFE33huH2IgRmRF7XhzdHeFUY9nQlQLw0t2eWobwf
         yymjA8HjhtJmBDrPznYvUw5N1Z6+dfgOLADQc3b/8Y89WW0UxPgknDALjf6IhioV8rw7
         J/fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777821864; x=1778426664;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dk44ltyjNXeb94AL68tKtmcqm1AiCDfhD8eU6ZDxGXM=;
        b=sx+rHSDjiu/CrXiYqqrsHcDAjdn5Eu0Pp9ARcZ98aI+ptjjc2bPQBEUvgaR+XgpxuL
         qrThv1q9I9xd9c1aKz9KdGeyJOLwYuHkFdMc0+KM+EOdhWnuj/PytHfKjNX9n/QczHUe
         11cSKkMCzCONF639HFCxYekvug5GMqB68ZPOlbqJiW1w6GU9YTKy86KulIFshiGx63Oa
         HmgzBmTdsPkUBlyKEZ5VuNyE9Zwh3vU7N6v/GDg10z5mghGP+xvr8iQL0Jj5sxprui/K
         KRjcWdmvoA9reI4TmAfpVkehHkvKBzGnzCo7Gw+B5v0e+L4XOeb0r92/kVyq9Jv4oYga
         tynA==
X-Forwarded-Encrypted: i=1; AFNElJ8k6/AMTfu1jk+hJa1HzCmm1vFSQ6OtSP6BwWui7jcttfxbTHi/yyKmTEJu+PgD5HkUI2RYGmy3vnxz@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2InXK7dOidxgV+M7/q7PRpYYdcdwbrZ7R8mct0WRQjEkIRxYH
	/ZrvtZy/sFLuLLFMlO5rMIDaN35wG/xbE5YN1DC0BKHsAcaTtFaznA5UA4lqeobvaOpMQ+WqDfD
	PFAjMJARKrxUKnhMgC2N1UWSbMmVazV8=
X-Gm-Gg: AeBDiet8FTBxdnAdw610rjHwhj/V7CCy47ccR4Qm9u9msVSRjcZ73+TGgQpM2KrXyDm
	Er//N6ZItoESmrrIzxsEAcRyByivwPcPvsDBEvvtH3u6q7tWAPOIcAiKtLPX6Ckqnhnlc/8l7tY
	El8IIR6cFgkPTfi50rW3EAu48+fE9yYfvB+9o6igXVlA56tlKTa8Zj9AHqNtZlgG7iz2uaFvYxZ
	5CLejpQodEdUBA6PSTN4hSjH86y5ZjXT7gn199vagWoMYIC4BZ0IBwyFqq4MCXbiWqIg4cIcF9x
	w/GjRXPfE+wA3K9lT0sO6ZrK56Nt1R1KgiM0rK2cGDyZ4IBTexDOBBaF4cFfbFyPa+uD1rAFAch
	kmdwI0pWPvRwgemdj1+opXrUEAmeJ+OS2gfauvltplSFOr0bCygPhEdrSh7ikfNALKOUlFPBiUx
	q0kYsrRQrTiBr/cA0URJJdb9P7lltN17E=
X-Received: by 2002:a05:6214:478a:b0:8ae:655f:28a4 with SMTP id
 6a1803df08f44-8b668d10e79mr102257526d6.40.1777821864469; Sun, 03 May 2026
 08:24:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260420144747.662761-1-michael.bommarito@gmail.com>
In-Reply-To: <20260420144747.662761-1-michael.bommarito@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 3 May 2026 10:24:11 -0500
X-Gm-Features: AVHnY4LlGeS7TKEajg81BwnSaFWaKd4qKkA01CnCJWCOClc8KMuKvIz3J9czej8
Message-ID: <CAH2r5mv5wV6xJfmTNx3dTbs1wTDyYpLPsdq53butKq1N_OvAoQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: validate dacloffset before building DACL pointers
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Steve French <sfrench@samba.org>, Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending additional testing and review

On Mon, Apr 20, 2026 at 10:44=E2=80=AFAM Michael Bommarito
<michael.bommarito@gmail.com> wrote:
>
> parse_sec_desc(), build_sec_desc(), and the chown path in
> id_mode_to_cifs_acl() all add the server-supplied dacloffset to pntsd
> before proving a DACL header fits inside the returned security
> descriptor.
>
> On 32-bit builds a malicious server can return dacloffset near
> U32_MAX, wrap the derived DACL pointer below end_of_acl, and then slip
> past the later pointer-based bounds checks. build_sec_desc() and
> id_mode_to_cifs_acl() can then dereference DACL fields from the wrapped
> pointer in the chmod/chown rewrite paths.
>
> Validate dacloffset numerically before building any DACL pointer and
> reuse the same helper at the three DACL entry points.
>
> Fixes: bc3e9dd9d104 ("cifs: Change SIDs in ACEs while transferring file o=
wnership.")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-6
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> ---
> This applies on top of
>
>   [PATCH v2] smb: client: validate the whole DACL before rewriting it
>   in cifsacl
>   https://lore.kernel.org/linux-cifs/20260420001131.2865776-1-michael.bom=
marito@gmail.com/
>
> so that the new dacl_offset_valid() numeric precheck sits upstream of
> that series' validate_dacl() structural check at all three call sites.
> The two patches are independent fixes for different bug classes on the
> same three entry points; applying this one without the KCIFS2 v2 patch
> first will fail on the build_sec_desc() hunk because the trailing
> context line "rc =3D validate_dacl(dacl_ptr, end_of_acl)" only exists
> after v2.  If you prefer a different ordering, happy to reroll on a
> plain mainline base instead.
>
>  fs/smb/client/cifsacl.c | 35 ++++++++++++++++++++++++++++++++---
>  1 file changed, 32 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
> index cb4060ba5e31..87d2a58fc8b4 100644
> --- a/fs/smb/client/cifsacl.c
> +++ b/fs/smb/client/cifsacl.c
> @@ -1263,6 +1263,17 @@ static int parse_sid(struct smb_sid *psid, char *e=
nd_of_acl)
>         return 0;
>  }
>
> +static bool dacl_offset_valid(unsigned int acl_len, __u32 dacloffset)
> +{
> +       if (acl_len < sizeof(struct smb_acl))
> +               return false;
> +
> +       if (dacloffset < sizeof(struct smb_ntsd))
> +               return false;
> +
> +       return dacloffset <=3D acl_len - sizeof(struct smb_acl);
> +}
> +
>
>  /* Convert CIFS ACL to POSIX form */
>  static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
> @@ -1283,7 +1294,6 @@ static int parse_sec_desc(struct cifs_sb_info *cifs=
_sb,
>         group_sid_ptr =3D (struct smb_sid *)((char *)pntsd +
>                                 le32_to_cpu(pntsd->gsidoffset));
>         dacloffset =3D le32_to_cpu(pntsd->dacloffset);
> -       dacl_ptr =3D (struct smb_acl *)((char *)pntsd + dacloffset);
>         cifs_dbg(NOISY, "revision %d type 0x%x ooffset 0x%x goffset 0x%x =
sacloffset 0x%x dacloffset 0x%x\n",
>                  pntsd->revision, pntsd->type, le32_to_cpu(pntsd->osidoff=
set),
>                  le32_to_cpu(pntsd->gsidoffset),
> @@ -1314,11 +1324,18 @@ static int parse_sec_desc(struct cifs_sb_info *ci=
fs_sb,
>                 return rc;
>         }
>
> -       if (dacloffset)
> +       if (dacloffset) {
> +               if (!dacl_offset_valid(acl_len, dacloffset)) {
> +                       cifs_dbg(VFS, "Server returned illegal DACL offse=
t\n");
> +                       return -EINVAL;
> +               }
> +
> +               dacl_ptr =3D (struct smb_acl *)((char *)pntsd + dacloffse=
t);
>                 parse_dacl(dacl_ptr, end_of_acl, owner_sid_ptr,
>                            group_sid_ptr, fattr, get_mode_from_special_si=
d);
> -       else
> +       } else {
>                 cifs_dbg(FYI, "no ACL\n"); /* BB grant all or default per=
ms? */
> +       }
>
>         return rc;
>  }
> @@ -1341,6 +1358,11 @@ static int build_sec_desc(struct smb_ntsd *pntsd, =
struct smb_ntsd *pnntsd,
>
>         dacloffset =3D le32_to_cpu(pntsd->dacloffset);
>         if (dacloffset) {
> +               if (!dacl_offset_valid(secdesclen, dacloffset)) {
> +                       cifs_dbg(VFS, "Server returned illegal DACL offse=
t\n");
> +                       return -EINVAL;
> +               }
> +
>                 dacl_ptr =3D (struct smb_acl *)((char *)pntsd + dacloffse=
t);
>                 rc =3D validate_dacl(dacl_ptr, end_of_acl);
>                 if (rc)
> @@ -1709,6 +1731,12 @@ id_mode_to_cifs_acl(struct inode *inode, const cha=
r *path, __u64 *pnmode,
>                 nsecdesclen =3D sizeof(struct smb_ntsd) + (sizeof(struct =
smb_sid) * 2);
>                 dacloffset =3D le32_to_cpu(pntsd->dacloffset);
>                 if (dacloffset) {
> +                       if (!dacl_offset_valid(secdesclen, dacloffset)) {
> +                               cifs_dbg(VFS, "Server returned illegal DA=
CL offset\n");
> +                               rc =3D -EINVAL;
> +                               goto id_mode_to_cifs_acl_exit;
> +                       }
> +
>                         dacl_ptr =3D (struct smb_acl *)((char *)pntsd + d=
acloffset);
>                         rc =3D validate_dacl(dacl_ptr, (char *)pntsd + se=
cdesclen);
>                         if (rc) {
> @@ -1751,6 +1779,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char=
 *path, __u64 *pnmode,
>                 rc =3D ops->set_acl(pnntsd, nsecdesclen, inode, path, acl=
flag);
>                 cifs_dbg(NOISY, "set_cifs_acl rc: %d\n", rc);
>         }
> +id_mode_to_cifs_acl_exit:
>         cifs_put_tlink(tlink);
>
>         kfree(pnntsd);
> --
> 2.53.0
>
>


--=20
Thanks,

Steve
