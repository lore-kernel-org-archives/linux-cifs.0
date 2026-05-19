Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2E7407CD6
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 16:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779208120; cv=pass; b=Plnsoy599pAWFHKnQprrN6FOYHfCecCYdGWXbDTfvIXImL7VHkeXOPwY/LyV6ee2sDgyg6QnilcGCKPQtE7Ycwhv2cSnGbrp3liNDqGhAA94/mTG4ShBdgMvTezUcgPuSNkZUL/3te56VfIV0+/q8ZMNJyUN7GOylJhYHEcA6XQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779208120; c=relaxed/simple;
	bh=HqGicqgp8L68BB1oRqf3T6O/DZvtjoc6FkbxGgVtiUg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pzn4AZXhI5K9PewrqMybOOGoFAmzJkq35v+PXfTaAQ6rUI5EVCPNx3r8rHCiaYn8Rk2bAMpe0tOkwmx3IlodWT36zAhrQMAC6O7/hYbcz01SMFHUGYnJgd+eNfvI4KxKOnKTbQwbqeSOzHZwGCULZixDFtGLKxn5DHt9kl+qZA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YT0OQd25; arc=pass smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YT0OQd25"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8b3fe2f19a4so42353976d6.2
        for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 09:28:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779208118; cv=none;
        d=google.com; s=arc-20240605;
        b=PAUYNtpW/F+O1GqtbzffZxV1iNkR8rpNqISeQcw2/0WpP1ECgGIgprWpOsM9k/uGDk
         KMrt9RhJ59yruMMFZgMKXihJqhb/RSvtxo5NKcv/RCKoaNxKdbhAkKmHhlqO0zM3nx1D
         S9Sh4CgNK7Ih8XRVFtNu44Y8WzfzrAVs5kGFEXwxBRNYybQ1d6Ti6vxfknIpqQjLJoip
         Zbo57TFrIqVxcNZJp6dBdR3TK7oLHovFYni2wFO+cBaPlHmbLTdcbIZqyla1J6BmahO6
         LVRUceOkTy9SHtuGB6E+YPYC8Sr26Yyo3eu0Jzj2WP0Vy47qrAD4FWqWVodZsoArEdPi
         NyTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gi9gZmr8U0J3VGl5olYMXfh+hrHiOvSyeFQLl4+U6T0=;
        fh=yBui7dhgD3eQEvjCiFxe5ja+jlcytP1BTiEXegpdHbU=;
        b=gRtO3WWZ7OH5FXIURngAo2HjFGPARbda4woFwwEdBF7RtFsqsdzqS2KBslP6AkD9VM
         h8zK0sGh1bMSDSieBRXtsRDOQtumI+EH5FpchTFhEMu4kI/XnFbmP3FAZT7uMpMIiGhG
         D5YuM3khiMvvCJtycLoVk+7DVo7t2TQLGR+mKQqDi0siCnwXBt6GK3vThWBAbepw+ss2
         xxhvaFB8UQMYEmtdwj0IX4FbFd9Ej7Mq39MvJd2MQduPsIDiy/j2zRdE/1RpaUzcRZTF
         Lk/H6e/ZojmpiYbAYog6dhxAogRk3we4JSKM7/4168UtUh33RkeuJIPexEFSbvwA1xrj
         4xKA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779208118; x=1779812918; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gi9gZmr8U0J3VGl5olYMXfh+hrHiOvSyeFQLl4+U6T0=;
        b=YT0OQd25XADYhTEwhmHEpx5+/yXLy2vGsV7E/isixmVlyQ44zvfsYUkCcpC5j/7NX7
         j8sEeAfNYu/0PP3BeVv9hQ9YY0qeNf1blAYjcuGOXQgsgwz5aBekc3K+r/jxpuKkGKgE
         c9C+hbxGvDWRE/CRaCQsmISpwOPJZfc7CbfQFHfAOWx7QNHGPWLOzBo37K0i6OSl/LB4
         Dh1ORE3Tzg4tjmrkO4IMx2HlSZ7CyYBhdxasIyn+sSe5FpndVdQHgm8TKpbhvJji25VI
         q1exE1dgvpMeDNaSrRFvn5qZR7FihF/sNxKZRSPDNsMl2dgEnvuvKeSBmizNl/rl2dmZ
         hwRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779208118; x=1779812918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gi9gZmr8U0J3VGl5olYMXfh+hrHiOvSyeFQLl4+U6T0=;
        b=K2hwDykDEA0IhbbhnKfp2qzbEzu80S/JoAy/SluBdkHWthG/iVWB3t1J5AZR9fbbqs
         4asBVbnIPUWpt1EhUtOJok6qRhlfdq6k+uMv1zbA5mFPMQFs+UJRoEykXzP+h89VJl8w
         UMQmj9RI6MbxCi0wpqR0qIO2CtYiA6wqYhGPw0agPvOU7zUhx2wRv5XUGh26MJUU1Exe
         6WUryzIyDcHZlKOeNVo6piv8rclTbLTLOK3R2AiMus1YYnXYJjlN7U9A5ek7ohFuLVBw
         7Akb6nmH7fadc/6HHh+mKT+mQKZXkOfaTW9CdZ1VEc/+d8g8JZoPG8QSybOlblbwnDa4
         JkvQ==
X-Gm-Message-State: AOJu0YzYm9tSF5lZmhvq5vUxzJL0WyWfOTs3I8w434LAeZYlNoD4ahLH
	oEngntetqDvuDN6bU7bayV4L+0wjZ3TsJlUKDfOQMz6LIUavYvljanN1UET9N6I8OA1/S0Xv0Et
	qc6P5d8PKcP2aDZ/9jHSNW1xEOmz6L7g=
X-Gm-Gg: Acq92OE9cf7zb6ufXghKultkfgHVO8ldXq6C0Qaj7SG8ashG0/hZYsI4lAM24KO38W1
	FoTF5FnOHr+ME3O22aTAryeT79Lq2fi06o1euIX8kKDg7MwaujtqgdqbRQjBfLGWSaVlS/DTW2A
	BisJcbcBS+z/QYLFXuka5ttLF19KpmlpdaDw0T50Iq5BOiZt41oq0g5+jLy7EyWTMF/pU/LS2Bm
	qjOON1UuhCBV/k/RumpHtxsHktKZSm5L55c9bb9MtAYfh5dHci/TviVWx9fzK7sGgU/7wFvOU21
	aBmiCEAuAcOrpWEO7uDLcINP3cGrimSE9WNBbQKWw3kQiqCRsKexf265l2k9q0pDCVzS0kLBNml
	nT5szWAu7yIuHJ/TZjJ0RBXwzGQz3QgDIbxmYsl5P5wUDMKojjtfAy7r3/t3i3L45qcdEA4jGab
	eApP124x9+4cxEstdxriD17Q==
X-Received: by 2002:a05:6214:450b:b0:89c:e4c3:dc1a with SMTP id
 6a1803df08f44-8ca0f601c4cmr329324846d6.1.1779208117404; Tue, 19 May 2026
 09:28:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260519023618.73569-1-q.h.hack.winter@gmail.com>
In-Reply-To: <20260519023618.73569-1-q.h.hack.winter@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 19 May 2026 11:28:24 -0500
X-Gm-Features: AVHnY4LlnGWddbyQ4AL_nMEnu1PbfmuLZfyoCHIKJjREJjrTxaGKddCJyk8ig7s
Message-ID: <CAH2r5mtb9UzcRVymcFavS79EiAsGF=C_nQgHeeZ-JgFr+OvY8g@mail.gmail.com>
Subject: Re: [RFC PATCH] cifs: validate full SID length in security descriptors
To: Qihang <q.h.hack.winter@gmail.com>
Cc: linux-cifs@vger.kernel.org, sfrench@samba.org, gregkh@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending testing and additional review

On Mon, May 18, 2026 at 9:36=E2=80=AFPM Qihang <q.h.hack.winter@gmail.com> =
wrote:
>
> parse_sid() only verified that the fixed SID header fit in the
> returned security descriptor, but did not verify that the full SID
> body described by num_subauth was present.
>
> A malicious server can return a truncated owner or group SID whose
> header lies within the descriptor buffer while sub_auth[] extends
> past the end of the allocation, leading to an out-of-bounds read
> when the client later parses or copies that SID.
>
> Validate the full SID body in parse_sid(), centralize owner/group SID
> lookup and bounds checking in sid_from_sd(), and use that validation
> in parse_sec_desc(), build_sec_desc(), and copy_sec_desc() before
> sub_auth[] is accessed.
>
> Signed-off-by: Qihang <q.h.hack.winter@gmail.com>
> ---
>  fs/smb/client/cifsacl.c | 196 ++++++++++++++++++++++++++--------------
>  1 file changed, 129 insertions(+), 67 deletions(-)
>
> diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
> index 786dbbc43c5b..42a3115359da 100644
> --- a/fs/smb/client/cifsacl.c
> +++ b/fs/smb/client/cifsacl.c
> @@ -275,6 +275,73 @@ cifs_copy_sid(struct smb_sid *dst, const struct smb_=
sid *src)
>         return size;
>  }
>
> +static int parse_sid(const struct smb_sid *psid, const char *end_of_acl)
> +{
> +       unsigned int sid_len;
> +
> +       /* SID must contain the fixed header before num_subauth is truste=
d. */
> +       if (end_of_acl < (const char *)psid + CIFS_SID_BASE_SIZE) {
> +               cifs_dbg(VFS, "ACL too small to parse SID %p\n", psid);
> +               return -EINVAL;
> +       }
> +       if (psid->num_subauth > SID_MAX_SUB_AUTHORITIES) {
> +               cifs_dbg(VFS, "SID contains too many subauthorities %u\n"=
,
> +                        psid->num_subauth);
> +               return -EINVAL;
> +       }
> +
> +       sid_len =3D CIFS_SID_BASE_SIZE + psid->num_subauth * sizeof(__le3=
2);
> +       if (end_of_acl < (const char *)psid + sid_len) {
> +               cifs_dbg(VFS, "ACL too small to parse SID %p\n", psid);
> +               return -EINVAL;
> +       }
> +
> +#ifdef CONFIG_CIFS_DEBUG2
> +       if (psid->num_subauth) {
> +               int i;
> +
> +               cifs_dbg(FYI, "SID revision %d num_auth %d\n",
> +                        psid->revision, psid->num_subauth);
> +
> +               for (i =3D 0; i < psid->num_subauth; i++) {
> +                       cifs_dbg(FYI, "SID sub_auth[%d]: 0x%x\n",
> +                                i, le32_to_cpu(psid->sub_auth[i]));
> +               }
> +
> +               cifs_dbg(FYI, "RID 0x%x\n",
> +                        le32_to_cpu(psid->sub_auth[psid->num_subauth - 1=
]));
> +       }
> +#endif
> +
> +       return 0;
> +}
> +
> +static int sid_from_sd(const struct smb_ntsd *pntsd, __u32 secdesclen,
> +                      __u32 sid_offset, struct smb_sid **sid)
> +{
> +       struct smb_sid *psid;
> +       char *end_of_acl;
> +
> +       if (secdesclen < sizeof(struct smb_ntsd)) {
> +               cifs_dbg(VFS, "ACL too small to parse security descriptor=
\n");
> +               return -EINVAL;
> +       }
> +       end_of_acl =3D (char *)pntsd + secdesclen;
> +
> +       if (sid_offset < sizeof(struct smb_ntsd) ||
> +           sid_offset > secdesclen - CIFS_SID_BASE_SIZE) {
> +               cifs_dbg(VFS, "Server returned illegal SID offset\n");
> +               return -EINVAL;
> +       }
> +
> +       psid =3D (struct smb_sid *)((char *)pntsd + sid_offset);
> +       if (parse_sid(psid, end_of_acl))
> +               return -EINVAL;
> +
> +       *sid =3D psid;
> +       return 0;
> +}
> +
>  static int
>  id_to_sid(unsigned int cid, uint sidtype, struct smb_sid *ssid)
>  {
> @@ -515,14 +582,14 @@ exit_cifs_idmap(void)
>  }
>
>  /* copy ntsd, owner sid, and group sid from a security descriptor to ano=
ther */
> -static __u32 copy_sec_desc(const struct smb_ntsd *pntsd,
> -                               struct smb_ntsd *pnntsd,
> -                               __u32 sidsoffset,
> -                               struct smb_sid *pownersid,
> -                               struct smb_sid *pgrpsid)
> +static int copy_sec_desc(const struct smb_ntsd *pntsd, struct smb_ntsd *=
pnntsd,
> +                        __u32 sidsoffset, __u32 secdesclen,
> +                        __u32 *pnsecdesclen, struct smb_sid *pownersid,
> +                        struct smb_sid *pgrpsid)
>  {
>         struct smb_sid *owner_sid_ptr, *group_sid_ptr;
>         struct smb_sid *nowner_sid_ptr, *ngroup_sid_ptr;
> +       int rc;
>
>         /* copy security descriptor control portion */
>         pnntsd->revision =3D pntsd->revision;
> @@ -533,28 +600,34 @@ static __u32 copy_sec_desc(const struct smb_ntsd *p=
ntsd,
>         pnntsd->gsidoffset =3D cpu_to_le32(sidsoffset + sizeof(struct smb=
_sid));
>
>         /* copy owner sid */
> -       if (pownersid)
> +       if (pownersid) {
>                 owner_sid_ptr =3D pownersid;
> -       else
> -               owner_sid_ptr =3D (struct smb_sid *)((char *)pntsd +
> -                               le32_to_cpu(pntsd->osidoffset));
> +       } else {
> +               rc =3D sid_from_sd(pntsd, secdesclen,
> +                                le32_to_cpu(pntsd->osidoffset), &owner_s=
id_ptr);
> +               if (rc)
> +                       return rc;
> +       }
>         nowner_sid_ptr =3D (struct smb_sid *)((char *)pnntsd + sidsoffset=
);
>         cifs_copy_sid(nowner_sid_ptr, owner_sid_ptr);
>
>         /* copy group sid */
> -       if (pgrpsid)
> +       if (pgrpsid) {
>                 group_sid_ptr =3D pgrpsid;
> -       else
> -               group_sid_ptr =3D (struct smb_sid *)((char *)pntsd +
> -                               le32_to_cpu(pntsd->gsidoffset));
> +       } else {
> +               rc =3D sid_from_sd(pntsd, secdesclen,
> +                                le32_to_cpu(pntsd->gsidoffset), &group_s=
id_ptr);
> +               if (rc)
> +                       return rc;
> +       }
>         ngroup_sid_ptr =3D (struct smb_sid *)((char *)pnntsd + sidsoffset=
 +
>                                         sizeof(struct smb_sid));
>         cifs_copy_sid(ngroup_sid_ptr, group_sid_ptr);
>
> -       return sidsoffset + (2 * sizeof(struct smb_sid));
> +       *pnsecdesclen =3D sidsoffset + (2 * sizeof(struct smb_sid));
> +       return 0;
>  }
>
> -
>  /*
>     change posix mode to reflect permissions
>     pmode is the existing mode (we only want to overwrite part of this
> @@ -1232,38 +1305,6 @@ static int set_chmod_dacl(struct smb_acl *pdacl, s=
truct smb_acl *pndacl,
>         return 0;
>  }
>
> -static int parse_sid(struct smb_sid *psid, char *end_of_acl)
> -{
> -       /* BB need to add parm so we can store the SID BB */
> -
> -       /* validate that we do not go past end of ACL - sid must be at le=
ast 8
> -          bytes long (assuming no sub-auths - e.g. the null SID */
> -       if (end_of_acl < (char *)psid + 8) {
> -               cifs_dbg(VFS, "ACL too small to parse SID %p\n", psid);
> -               return -EINVAL;
> -       }
> -
> -#ifdef CONFIG_CIFS_DEBUG2
> -       if (psid->num_subauth) {
> -               int i;
> -               cifs_dbg(FYI, "SID revision %d num_auth %d\n",
> -                        psid->revision, psid->num_subauth);
> -
> -               for (i =3D 0; i < psid->num_subauth; i++) {
> -                       cifs_dbg(FYI, "SID sub_auth[%d]: 0x%x\n",
> -                                i, le32_to_cpu(psid->sub_auth[i]));
> -               }
> -
> -               /* BB add length check to make sure that we do not have h=
uge
> -                       num auths and therefore go off the end */
> -               cifs_dbg(FYI, "RID 0x%x\n",
> -                        le32_to_cpu(psid->sub_auth[psid->num_subauth-1])=
);
> -       }
> -#endif
> -
> -       return 0;
> -}
> -
>  static bool dacl_offset_valid(unsigned int acl_len, __u32 dacloffset)
>  {
>         if (acl_len < sizeof(struct smb_acl))
> @@ -1284,23 +1325,25 @@ static int parse_sec_desc(struct cifs_sb_info *ci=
fs_sb,
>         int rc =3D 0;
>         struct smb_sid *owner_sid_ptr, *group_sid_ptr;
>         struct smb_acl *dacl_ptr; /* no need for SACL ptr */
> -       char *end_of_acl =3D ((char *)pntsd) + acl_len;
> -       __u32 dacloffset;
> +       char *end_of_acl;
> +       __u32 dacloffset, osidoffset, gsidoffset;
>
>         if (pntsd =3D=3D NULL)
>                 return smb_EIO(smb_eio_trace_null_pointers);
> +       if (acl_len < (int)sizeof(struct smb_ntsd)) {
> +               cifs_dbg(VFS, "ACL too small to parse security descriptor=
\n");
> +               return -EINVAL;
> +       }
> +       end_of_acl =3D ((char *)pntsd) + acl_len;
>
> -       owner_sid_ptr =3D (struct smb_sid *)((char *)pntsd +
> -                               le32_to_cpu(pntsd->osidoffset));
> -       group_sid_ptr =3D (struct smb_sid *)((char *)pntsd +
> -                               le32_to_cpu(pntsd->gsidoffset));
> +       osidoffset =3D le32_to_cpu(pntsd->osidoffset);
> +       gsidoffset =3D le32_to_cpu(pntsd->gsidoffset);
>         dacloffset =3D le32_to_cpu(pntsd->dacloffset);
>         cifs_dbg(NOISY, "revision %d type 0x%x ooffset 0x%x goffset 0x%x =
sacloffset 0x%x dacloffset 0x%x\n",
> -                pntsd->revision, pntsd->type, le32_to_cpu(pntsd->osidoff=
set),
> -                le32_to_cpu(pntsd->gsidoffset),
> +                pntsd->revision, pntsd->type, osidoffset, gsidoffset,
>                  le32_to_cpu(pntsd->sacloffset), dacloffset);
>  /*     cifs_dump_mem("owner_sid: ", owner_sid_ptr, 64); */
> -       rc =3D parse_sid(owner_sid_ptr, end_of_acl);
> +       rc =3D sid_from_sd(pntsd, acl_len, osidoffset, &owner_sid_ptr);
>         if (rc) {
>                 cifs_dbg(FYI, "%s: Error %d parsing Owner SID\n", __func_=
_, rc);
>                 return rc;
> @@ -1312,9 +1355,9 @@ static int parse_sec_desc(struct cifs_sb_info *cifs=
_sb,
>                 return rc;
>         }
>
> -       rc =3D parse_sid(group_sid_ptr, end_of_acl);
> +       rc =3D sid_from_sd(pntsd, acl_len, gsidoffset, &group_sid_ptr);
>         if (rc) {
> -               cifs_dbg(FYI, "%s: Error %d mapping Owner SID to gid\n",
> +               cifs_dbg(FYI, "%s: Error %d parsing Group SID\n",
>                          __func__, rc);
>                 return rc;
>         }
> @@ -1354,8 +1397,15 @@ static int build_sec_desc(struct smb_ntsd *pntsd, =
struct smb_ntsd *pnntsd,
>         struct smb_sid *nowner_sid_ptr =3D NULL, *ngroup_sid_ptr =3D NULL=
;
>         struct smb_acl *dacl_ptr =3D NULL;  /* no need for SACL ptr */
>         struct smb_acl *ndacl_ptr =3D NULL; /* no need for SACL ptr */
> -       char *end_of_acl =3D ((char *)pntsd) + secdesclen;
> +       char *end_of_acl;
>         u16 size =3D 0;
> +       __u32 osidoffset, gsidoffset;
> +
> +       if (secdesclen < sizeof(struct smb_ntsd)) {
> +               cifs_dbg(VFS, "ACL too small to parse security descriptor=
\n");
> +               return -EINVAL;
> +       }
> +       end_of_acl =3D ((char *)pntsd) + secdesclen;
>
>         dacloffset =3D le32_to_cpu(pntsd->dacloffset);
>         if (dacloffset) {
> @@ -1370,10 +1420,18 @@ static int build_sec_desc(struct smb_ntsd *pntsd,=
 struct smb_ntsd *pnntsd,
>                         return rc;
>         }
>
> -       owner_sid_ptr =3D (struct smb_sid *)((char *)pntsd +
> -                       le32_to_cpu(pntsd->osidoffset));
> -       group_sid_ptr =3D (struct smb_sid *)((char *)pntsd +
> -                       le32_to_cpu(pntsd->gsidoffset));
> +       osidoffset =3D le32_to_cpu(pntsd->osidoffset);
> +       gsidoffset =3D le32_to_cpu(pntsd->gsidoffset);
> +       rc =3D sid_from_sd(pntsd, secdesclen, osidoffset, &owner_sid_ptr)=
;
> +       if (rc) {
> +               cifs_dbg(FYI, "%s: Error %d parsing Owner SID\n", __func_=
_, rc);
> +               return rc;
> +       }
> +       rc =3D sid_from_sd(pntsd, secdesclen, gsidoffset, &group_sid_ptr)=
;
> +       if (rc) {
> +               cifs_dbg(FYI, "%s: Error %d parsing Group SID\n", __func_=
_, rc);
> +               return rc;
> +       }
>
>         if (pnmode && *pnmode !=3D NO_CHANGE_64) { /* chmod */
>                 ndacloffset =3D sizeof(struct smb_ntsd);
> @@ -1389,8 +1447,10 @@ static int build_sec_desc(struct smb_ntsd *pntsd, =
struct smb_ntsd *pnntsd,
>
>                 sidsoffset =3D ndacloffset + le16_to_cpu(ndacl_ptr->size)=
;
>                 /* copy the non-dacl portion of secdesc */
> -               *pnsecdesclen =3D copy_sec_desc(pntsd, pnntsd, sidsoffset=
,
> -                               NULL, NULL);
> +               rc =3D copy_sec_desc(pntsd, pnntsd, sidsoffset, secdescle=
n,
> +                                  pnsecdesclen, NULL, NULL);
> +               if (rc)
> +                       return rc;
>
>                 *aclflag |=3D CIFS_ACL_DACL;
>         } else {
> @@ -1467,8 +1527,10 @@ static int build_sec_desc(struct smb_ntsd *pntsd, =
struct smb_ntsd *pnntsd,
>
>                 sidsoffset =3D ndacloffset + le16_to_cpu(ndacl_ptr->size)=
;
>                 /* copy the non-dacl portion of secdesc */
> -               *pnsecdesclen =3D copy_sec_desc(pntsd, pnntsd, sidsoffset=
,
> -                               nowner_sid_ptr, ngroup_sid_ptr);
> +               rc =3D copy_sec_desc(pntsd, pnntsd, sidsoffset, secdescle=
n,
> +                                  pnsecdesclen, nowner_sid_ptr, ngroup_s=
id_ptr);
> +               if (rc)
> +                       goto chown_chgrp_exit;
>
>  chown_chgrp_exit:
>                 /* errors could jump here. So make sure we return soon af=
ter this */
> --
> 2.39.5 (Apple Git-154)
>


--=20
Thanks,

Steve
