Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C343336E496
	for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 21:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769896674; cv=pass; b=YKdUxlmh60fOJK9GwfEdJx7L3XpP/06Xx5IL7ibBji5lnIJLSbKNI3EUSJt/uQ/+UQp7whlvdFgwLUjd/2bU+nEKBsMvjKBHoK0ElPWbvLDusfqACBCmTSKPVAisoFM3Ji+NgReTIWpWMOy9WPNRwFQTxRFVAo4XVAOFPbUs08A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769896674; c=relaxed/simple;
	bh=Prn/fACwnmk0xgtPykFy4fNHzJnnEKWU+lkrptSgG1M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CDz1Jt1jIsPVquF78eKulVujQcYBF487USTEQ0XOoEL9f7q0WNZE2M85nyxQuRXlMtX7T201Vu8U0lGRYML9EUF4kFeTw5j+1mbejOHburxvZX1Z+Mbr+tTvqcrdniPZmXrQoLiW23icN4Po4bPrjnKb0QUpd1wk+6xA5gV2hmM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TmD8mgGA; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TmD8mgGA"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-502f101d1cfso29783591cf.1
        for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 13:57:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769896672; cv=none;
        d=google.com; s=arc-20240605;
        b=WxyfATQY2KGAfx0gg/OOzGlEOL8euycWsJcXYIigeEa9AUeuj8n+oc3C0aKQKnQY/3
         gx/wJFl+MNqa/i1W36EtmKjPHfFww/FPVgOVfQz6fl5RdHJwRb28CyAn04zJpA2bviJ/
         3vt21xIDCVhzhGnFglw3COfT78kgSOeanjzFGwcCYNar1V8tiNS4qizYNSvw+o6DDiBN
         05kzTMQFLbBzaW0ayu/z3JxcCbNt+wvI0SvhifaSHJdOVRWtWo+lV49IYlzLwkek8RQZ
         w6YL7/18Qq3+SaxRRbeNtiTYZDi0cB/njla90qIAJ753YfXW0d+5ODUmlQ4KTBe9383e
         UmVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vIvVBz0UstT/2uCKGEJmSDOmyBvPjiiiupa3+JR3Pn0=;
        fh=fz/wBVMx4xH19h6IcObuEdCqKjRJriuvIIIgaJAb4lU=;
        b=WCwTfyQU2IeIodBnFG2DAUmulEXHk3Np71Vko3yY/6Hi9AyeF6ulRcRDMsqOotiwwK
         +5H0TGUJisipxM4W3OrnFYFtep2A3ws4u2Nm/YeIGreNmEfHtuLgove0HeLSH6cfjwuF
         ecMXE4ct1BxAVRE74hd1VB/gwQQWzPUwCiY3rIKOZazUzodfxleEsS4Gu7Oc3TS02rAl
         pLRK47xHwyOSZuJqW43o8hZ6VwRNE0xh2bL71clwkHo/ZAW5fKCUylWfbj2tqRtKV1d+
         Fdf5Fyto8mEFEt/JCt526elYcJh5223uGg5K8siZa15b5dQDE287PEFwT/iMEcHU70qf
         TmNw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769896672; x=1770501472; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vIvVBz0UstT/2uCKGEJmSDOmyBvPjiiiupa3+JR3Pn0=;
        b=TmD8mgGAnkMowLhPglAdMxR7QSMXOcVF5U+EFQgqaj3d96z9CwDTb25O1ivPwGf8b8
         x4U7ATBMZJv4jF4rF73xyRaZYQ1RifPw544SCCH4f2LLGfqP7UmFZVwi72JJ98mYxuGh
         A2psWQGKrn5XZVU8ki8WjX6DiFY4OgQbUTnruikszDNXzlP5Sq16+4mom/cmUCmWFY/7
         +lQo9Q4ofuG8edal+mtN87EY8up4T7t0YOKpb9ffhCAMILv4MgOO4kublrNec+YP+DgV
         eQHpnin5lx+0DjFklC1YbzKuw+5OcRfTih2uAJqcW7u6Tk18CjuQbwrANPy+NwDISR2u
         8y4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769896672; x=1770501472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vIvVBz0UstT/2uCKGEJmSDOmyBvPjiiiupa3+JR3Pn0=;
        b=AjodsDpcQH46yG+Hb5hi+zysAVllkuTS4vJvDlbycXX35XlevlfA67Sr9OidVFlVbo
         NyPGFJWEoNJVJAO7XCOn0im7xeF1SeN+7044eFRg3MhcGBzK2HwTLuF42ceUhjZqZ3qk
         jALpZidKrL/GiBtfMUbdoDxP67HS2SYikoEG3141Ll1/AL6G7AxZxCUGrgHG/L/oKkro
         CUIJ0r/JI6sIkdRBKAHDNzLNHH29tI8m7a0q2XauMW7/wvl2a0yYXRnAt1rYbhxgFH+n
         qOYMBlAekhhJe1MYyE2oDTlLj5HxImRgmnnjryVNFeecKjtRZCE3jlAPs4LbTobBbAdb
         rn2A==
X-Gm-Message-State: AOJu0Yx2FUmmZddmsa5M4ILuQc57Z0MnhTDyzkZK5NOxrJNKnLlYsyIh
	JmezuVZr+irb44FZ3nsk7lvimXrVmDd/W69U8Lpll7MFUFM1rQaeje5bV0pqc+xrasBwQ/dOvcI
	5+YHM/qNttU58J3luF5Dl/w1hYBBL1b0mWaa6
X-Gm-Gg: AZuq6aLwulzNxi1wMKGLc4I5qd74kRmoCCFGJ9cBmZLxr5vwOkJs9pV4hvCxlLeg13U
	Y8TQrj7tvELWlkBjBxutNs8iPZ5ehVYo+Ubf480erZjG4blmHaGb2czGFzsXouy4cwoHPnW2kSn
	AQSV9B40p+l2eoKYp8l72dpE8lVkFDC7CrIU8ferxRioUcALdlSgpJhySWYAArsMGvuXOlldxcA
	+oxt+PO2YR1GWKY7bBHagFV/7VyVoyZoUGuO74+W1YmG+n4jvnkoi+5/ve2kb2kF28RajoIYS68
	zwnDJUEbWPLWM9P8PR+teW+/pqSkrd4FeRKRxv2UGo1TboxQuZr0RgYA9xKeKJkwzf2LS0toSKB
	25wLzTw2bVSlzMz0I2G1zC/0Cnmh55U1vEo2PMmfktwGsJoWsaOcvPOoFpTM9nPI57a2xXQYoY4
	Rzqx81rmNQ4Q==
X-Received: by 2002:a05:622a:d:b0:4ff:c295:3c3e with SMTP id
 d75a77b69052e-505d215193amr84416641cf.10.1769896671560; Sat, 31 Jan 2026
 13:57:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260131185238.973130-1-sprasad@microsoft.com>
In-Reply-To: <20260131185238.973130-1-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 31 Jan 2026 15:57:40 -0600
X-Gm-Features: AZwV_QgqTgpdWy8XU5eNzs2QaofKzkPOWCBrksnP_cwpxEzRdhXVQoCntppVo8o
Message-ID: <CAH2r5muGfp8iqxagjOvJs+Ye12RQPc6136B-eB9=+bm3HmBnLA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] cifs: Corrections to lock ordering notes
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com, ematsumiya@suse.de, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Fixed typo and merged these two to cifs-2.6.git for-next

On Sat, Jan 31, 2026 at 12:52=E2=80=AFPM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> There were a couple of discrepencies in lock ordering for the locks
> that were specified in the lock ordering notes. Did an analysis
> of the current codebase (using LLM) and found two pairs whose ordering
> in these notes were wrong. It also found one lock that was recently
> removed, and a few locks that weren't documented here before.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifsglob.h | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 3eca5bfb70303..d797b953b6cf6 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1943,6 +1943,8 @@ require use of the stronger protocol */
>   */
>
>  /***********************************************************************=
*****
> + * LOCK ORDERING NOTES:
> + ***********************************************************************=
*****
>   * Here are all the locks (spinlock, mutex, semaphore) in cifs.ko, arran=
ged according
>   * to the locking order. i.e. if two locks are to be held together, the =
lock that
>   * appears higher in this list needs to be taken before the other.
> @@ -1971,18 +1973,21 @@ require use of the stronger protocol */
>   * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>   * Lock                                Protects                        I=
nitialization fn
>   * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> + * cifs_mount_mutex            mount/unmount operations
>   * vol_list_lock
>   * vol_info->ctx_lock          vol_info->ctx
>   * cifs_sb_info->tlink_tree_lock       cifs_sb_info->tlink_tree        c=
ifs_setup_cifs_sb
>   * TCP_Server_Info->           TCP_Server_Info                 cifs_get_=
tcp_session
>   * reconnect_mutex
> - * TCP_Server_Info->srv_mutex  TCP_Server_Info                 cifs_get_=
tcp_session
>   * cifs_ses->session_mutex     cifs_ses                        sesInfoAl=
loc
> + * TCP_Server_Info->_srv_mutex TCP_Server_Info                 cifs_get_=
tcp_session

Fixed typo "_srv_mutex" should be "srv_mutex"

> + * cifs_tcp_ses_lock           cifs_tcp_ses_list               sesInfoAl=
loc

Would it be more logical to fix the code that calls it in the
unexpected order or fix the lock
description.  The original idea IIRC was to grab TCP session locks
before locks on things
that hang off it (like session, and tcon), but in this case it
probably is ok but curious if
changing the code would be more intuitive

>   * cifs_tcon->open_file_lock   cifs_tcon->openFileList         tconInfoA=
lloc
>   *                             cifs_tcon->pending_opens
>   * cifs_tcon->stat_lock                cifs_tcon->bytes_read           t=
conInfoAlloc
>   *                             cifs_tcon->bytes_written
> - * cifs_tcp_ses_lock           cifs_tcp_ses_list               sesInfoAl=
loc
> + * cifs_tcon->fscache_lock     cifs_tcon->fscache              tconInfoA=
lloc
> + * cifs_tcon->sb_list_lock     cifs_tcon->cifs_sb_list         tconInfoA=
lloc
>   * GlobalMid_Lock              GlobalMaxActiveXid              init_cifs
>   *                             GlobalCurrentXid
>   *                             GlobalTotalActiveXid
> @@ -2005,6 +2010,8 @@ require use of the stronger protocol */
>   *                             ->chans_in_reconnect
>   * cifs_tcon->tc_lock          (anything that is not protected by anothe=
r lock and can change)
>   *                                                             tcon_info=
_alloc
> + * cifs_swnreg_idr_mutex       cifs_swnreg_idr                 cifs_swn.=
c
> + *                             (witness service registration, accesses t=
con fields under tc_lock)
>   * inode->i_rwsem, taken by fs/netfs/locking.c e.g. should be taken befo=
re cifsInodeInfo locks
>   * cifsInodeInfo->open_file_lock       cifsInodeInfo->openFileList     c=
ifs_alloc_inode
>   * cifsInodeInfo->writers_lock cifsInodeInfo->writers          cifsInode=
Info_alloc
> @@ -2012,12 +2019,12 @@ require use of the stronger protocol */
>   *                             ->can_cache_brlcks
>   * cifsInodeInfo->deferred_lock        cifsInodeInfo->deferred_closes  c=
ifsInodeInfo_alloc
>   * cached_fids->cfid_list_lock cifs_tcon->cfids->entries       init_cach=
ed_dirs
> - * cached_fid->fid_lock                (anything that is not protected b=
y another lock and can change)
> - *                                                             init_cach=
ed_dir
> + * cached_fid->dirents.de_mutex        cached_fid->dirents             a=
lloc_cached_dir
>   * cifsFileInfo->fh_mutex      cifsFileInfo                    cifs_new_=
fileinfo
>   * cifsFileInfo->file_info_lock        cifsFileInfo->count             c=
ifs_new_fileinfo
>   *                             ->invalidHandle                 initiate_=
cifs_search
>   *                             ->oplock_break_cancelled
> + * smbdirect_mr->mutex         RDMA memory region management   (SMBDirec=
t only)
>   * mid_q_entry->mid_lock       mid_q_entry->callback           alloc_mid
>   *                                                             smb2_mid_=
entry_alloc
>   *                             (Any fields of mid_q_entry that will need=
 protection)
> --
> 2.43.0
>


--=20
Thanks,

Steve
