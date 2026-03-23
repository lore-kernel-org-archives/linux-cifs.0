Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AE73AA4EA
	for <linux-cifs@vger.kernel.org>; Mon, 23 Mar 2026 13:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774272133; cv=pass; b=IF6VPmjOJAlD9YUt13J6iqtgc8OKg6CtP7YPiDoLWdz/92X0D5PTO04bO6cIIBypiPT+dM3k2+coLxVUBz2iArwJb/6NA89GS4qzVcAtUb9uV0a87bAT7hzpP1VsSpAOr+LeAFbDy0yBgKvws7gODyWsF1tFpgCaPkcE7YiX4qE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774272133; c=relaxed/simple;
	bh=pOZf3ggKzaXnSWcs3uzk8GcTVpp0tFc4UkzfaBPxJzM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qoXoRh2DJabWpvE+7uWEFazqnisledNCUjVzjyRYikvB4k0e3XmyGQ3i67qwlxbvwR5kNv0y1rF2ik0tz2h2HQ6Q6b20C5hyMzHGSmkId+X3qPF9sgIxxbaJEA+Pa8znr4TmAzgErSga11Q5yd11NhJUHlSm1OPnhs8Asc4v0cs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LhuWBDZf; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LhuWBDZf"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-50b35f3e489so29120241cf.0
        for <linux-cifs@vger.kernel.org>; Mon, 23 Mar 2026 06:22:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774272130; cv=none;
        d=google.com; s=arc-20240605;
        b=CxieC84Vm2PUMOU8ElxooRm31lIXfDfs3SUXup+45Rv9om70Z8G9EuDu3/sAn2KNK+
         megZL+ENIsBZwx3Sh5qCLqOXAfV2kH7yik8a3n6l4cH/pvlp1fmg/DN5P4z15u/gcJ4Y
         Sd6HNSgWepq2e6sEshiiRY4e7fy9lcjORWGDmxvoCaeU2aST3w7Xk0Q6gTnWtYEzPBaF
         sLIqGUYU5qb/+IOQKjgdEPmU0gLxm633TkxBkX0nXR9KcH2AZn+abNlN4sZ21dPu/9Yg
         58IA89K+MKwsZNxEmbRHqHcF3o7hkx9ie718gKxXKl2oxRxflK+KRn1WRCYovKdVrSPj
         Y/PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dTiOKfx7i/Tgm0HXFocZLKaqOe68VqvbGNMyJx2KgzA=;
        fh=DkLMl/qJzEvd9tQgvO3JzBkOsTahPYgzaXZL0lOf/rY=;
        b=lZE4NZd28E8KnwkeWPgmeWK5xGX7VoAuWSY/526FiPA0j7Uk1ZlsD6OLxEJkGCOH3b
         R6/BbxL2m+VylK8jUGO9v5/dX+pCGEl/U69wWKN/JGxQKx0bh0ThM9CXKEffOXk8sSjR
         BDwaW2EUtXpI3gvqDDg51EH8pvNSWlFQwxFPTFOnnXrwR1vO2+DGWqBBi5SDnQXEhgIC
         dAZlRoZ650V6TJbPPJ/FRLDn3WUZq0XqVEI9FLsmAtCcRXYK3GrYrCtUoVXyn9LyECBw
         nC6E8kbvZQx2qHUkrE1foY3YjSyCNh0/X+6E6jW0K49zQk1cZSLUCJ/Yu7zliBZ1NGXW
         4nxA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774272130; x=1774876930; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dTiOKfx7i/Tgm0HXFocZLKaqOe68VqvbGNMyJx2KgzA=;
        b=LhuWBDZf1sotees38H+7pCFv32x5i/H3IgaJjfImPjNcX1KqjV3p2eJ7Q1fmBD8r0D
         Wqowsli+nJm0zS0DXaXXeAf4OUoiCnlhXZKINL5if6lpvkGoIWN2Na6GdChlDkNGaNbV
         ohTAlZQW96qOqKa1xZrE3U0VQl5/w1hFV9XvlHtmSIfrI68v0LiNHWxjVvN667WkOFos
         W1WQA4s1+xIXtJ3ttjQPjQ44yieRK3Y9QMr9yk9ef2vX1wRrh8X4NmB90FOr71wjc+TI
         ibArMYcqaxKYpuyet1k3wpziPVrYcb+clkv+xRPodQJqOjwCTbePm1/Hp+UQ7DnAzPkc
         qdhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774272130; x=1774876930;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dTiOKfx7i/Tgm0HXFocZLKaqOe68VqvbGNMyJx2KgzA=;
        b=iQxo8HTz40HjL2KxqqAeI3WGWWJAWCsM3naVHGpMnY+J5IiRzzQg30LSHfg7LfIbhe
         4m7KQw/NZZSsTM7QBZqqBbYqSGsz75hstOMztRkVRxOsLUmx/rI6k5mET8tm1Cs+Ei1F
         iuzZLnuyzaeZpoH4a8bC6X7peGmQREJTcZqnmeQpgwCD9CVoOIa592A6Ya089VZdf8F3
         xq4uW1bGesn3CQ7GR6WHdxkPA7vO5VWrhy2YKr3SJHKl6tgwagrMxwoJHCbStux7WZ4H
         mLzsX0pJyTWmjV7oOl/lpgPrgIbp/7fMKRRsMS4oeE6ja3IoMYp9IQqd9iE8taeYcSdf
         ohag==
X-Forwarded-Encrypted: i=1; AJvYcCW4Mohhf/PFyXIFd1ide3D1rshwO5w8I9IHYT5RnlhMC6ZTdqVRXXKsLLctWavB33aycfXnXEiGIY4f@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9JT8bqv0jpWEsxlUaP+4lFK6nNfsbqHytQRPyseIj/2wrIxx1
	AdvbP7KdTOKJ6OL7c7pW9/96vfQu2GcjMVunATssjoXB6PKIoEMrl44jR7Gy6wyf+rYAmeyWsvd
	VhDhUiMeYLuJCt4P34vbSbNJmtkQ9i48=
X-Gm-Gg: ATEYQzx5J3t/E94kYxiL6RLaESj0ApAfgccN+K86v3+sIBwuSi/oc82IaqUFOH0Gf+k
	KKKyFMr98tpxP+DWCMu+ldGA0s+ys30vPiN/GEjw/MjpBCQ5Yuhw5AOxMAgbaZy2JNq1oX54OP0
	fWFUmmjtvE1AWqRfGn7Zh69zyblLJbD0woCQvVkWJiQiPjds1lfvptfBird1rGYbInscp0pYye+
	ios2gRTZccLotVTwKDDnCf9a54A2oL1Uus4Cb2CfMmyT7VV9kyFbcOkimfZ5u0/ZTX1Qif497wp
	HxuDSPHyzwZaaYNZKOt7rId4TGYKWHRNKXrm+TMcJVDvjMljwxmTgCllQZmw0wFucZly1rEJ8KV
	4GW/Gayq5Y6hDyUmZXR9cZeOJpaN14i7syyoOxH+kx3YiugEezNMPezMwVyqRVRogHLGSQHorTY
	HNW624ZZ8ppe0HeufEDEl2rg==
X-Received: by 2002:a05:6214:449d:b0:89c:6692:1d83 with SMTP id
 6a1803df08f44-89c8543f16bmr179293256d6.3.1774272130234; Mon, 23 Mar 2026
 06:22:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202603180118.ClDWNtId-lkp@intel.com> <b859bfa1-7844-4b23-91a4-bbd526ffc19b@samba.org>
In-Reply-To: <b859bfa1-7844-4b23-91a4-bbd526ffc19b@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 23 Mar 2026 08:21:58 -0500
X-Gm-Features: AQROBzCBnQmmYkruPhQ2P1j2dNfaSC0ZtjlVbK8huEwU6tKFpem_8kw-eLtJn64
Message-ID: <CAH2r5mvvjWtJza+9YrLYvneysyEQa5rENhTYiFTAwrE+KhOy8Q@mail.gmail.com>
Subject: Re: [samba-ksmbd:ksmbd-for-next-next 11/12] fs/smb/server/smb2pdu.c:5723:3:
 warning: variable 'pntsd' is uninitialized when used here
To: Stefan Metzmacher <metze@samba.org>
Cc: Asim Viladi Oglu Manizada <manizada@pm.me>, Namjae Jeon <linkinjeon@kernel.org>, 
	kernel test robot <lkp@intel.com>, llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	Steve French <stfrench@microsoft.com>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

looks like a simple fix to initialize it to null at declaration, right?

On Mon, Mar 23, 2026 at 3:56=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Hi,
>
> I'm seeing the same thing in ksmbd-for-next now:
>
> 6a0795e46296589d8eba6c194586e9e65974d73f ksmbd: fix OOB write in QUERY_IN=
FO for compound requests
>
> smatch generates this error now:
>
> server/smb2pdu.c:5801 smb2_get_info_sec() error: uninitialized symbol 'pn=
tsd'.
>
> metze
>
> Am 17.03.26 um 18:55 schrieb kernel test robot:
> > tree:   git://git.samba.org/ksmbd.git ksmbd-for-next-next
> > head:   a58d8c8b3d5daee33fb03f4d41ea278ae6e6ffc9
> > commit: 095198efe2c86423f647b242687c50e34e355d3a [11/12] ksmbd: fix hea=
p OOB write in QUERY_INFO for compound requests
> > config: arm-randconfig-003-20260317 (https://download.01.org/0day-ci/ar=
chive/20260318/202603180118.ClDWNtId-lkp@intel.com/config)
> > compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project=
 4abb927bacf37f18f6359a41639a6d1b3bffffb5)
> > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/arc=
hive/20260318/202603180118.ClDWNtId-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202603180118.ClDWNtId-l=
kp@intel.com/
> >
> > All warnings (new ones prefixed by >>):
> >
> >>> fs/smb/server/smb2pdu.c:5723:3: warning: variable 'pntsd' is uninitia=
lized when used here [-Wuninitialized]
> >      5723 |                 pntsd->revision =3D cpu_to_le16(1);
> >           |                 ^~~~~
> >     fs/smb/server/smb2pdu.c:5708:24: note: initialize the variable 'pnt=
sd' to silence this warning
> >      5708 |         struct smb_ntsd *pntsd, *ppntsd =3D NULL;
> >           |                               ^
> >           |                                =3D NULL
> >     1 warning generated.
> >
> >
> > vim +/pntsd +5723 fs/smb/server/smb2pdu.c
> >
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5701
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5702  static int smb2_get_info_sec(struct ksmbd_work *work,
> > 64b39f4a2fd293 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-30  5703                          struct smb2_query_info_req *req,
> > cb4517201b8acd fs/ksmbd/smb2pdu.c      Namjae Jeon               2021-1=
1-03  5704                          struct smb2_query_info_rsp *rsp)
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5705  {
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5706     struct ksmbd_file *fp;
> > 4609e1f18e19c3 fs/ksmbd/smb2pdu.c      Christian Brauner         2023-0=
1-13  5707     struct mnt_idmap *idmap;
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5708     struct smb_ntsd *pntsd, *ppntsd =3D NULL;
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5709     struct smb_fattr fattr =3D {{0}};
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5710     struct inode *inode;
> > 8f0541186e9ad1 fs/ksmbd/smb2pdu.c      Namjae Jeon               2022-0=
8-02  5711     __u32 secdesclen =3D 0;
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5712     unsigned int id =3D KSMBD_NO_FID, pid =3D KSMBD_NO_FID;
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5713     int addition_info =3D le32_to_cpu(req->AdditionalInformation=
);
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5714     int rc =3D 0, ppntsd_size =3D 0, max_len;
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5715     size_t scratch_len;
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5716
> > e294f78d347851 fs/ksmbd/smb2pdu.c      Namjae Jeon               2021-0=
6-28  5717     if (addition_info & ~(OWNER_SECINFO | GROUP_SECINFO | DACL_S=
ECINFO |
> > e294f78d347851 fs/ksmbd/smb2pdu.c      Namjae Jeon               2021-0=
6-28  5718                           PROTECTED_DACL_SECINFO |
> > e294f78d347851 fs/ksmbd/smb2pdu.c      Namjae Jeon               2021-0=
6-28  5719                           UNPROTECTED_DACL_SECINFO)) {
> > 8e537d1465e740 fs/ksmbd/smb2pdu.c      Namjae Jeon               2021-1=
1-21  5720             ksmbd_debug(SMB, "Unsupported addition info: 0x%x)\n=
",
> > ced2b26a76cd1d fs/cifsd/smb2pdu.c      Sebastian Gottschall      2021-0=
4-27  5721                    addition_info);
> > ced2b26a76cd1d fs/cifsd/smb2pdu.c      Sebastian Gottschall      2021-0=
4-27  5722
> > ced2b26a76cd1d fs/cifsd/smb2pdu.c      Sebastian Gottschall      2021-0=
4-27 @5723             pntsd->revision =3D cpu_to_le16(1);
> > ced2b26a76cd1d fs/cifsd/smb2pdu.c      Sebastian Gottschall      2021-0=
4-27  5724             pntsd->type =3D cpu_to_le16(SELF_RELATIVE | DACL_PRO=
TECTED);
> > ced2b26a76cd1d fs/cifsd/smb2pdu.c      Sebastian Gottschall      2021-0=
4-27  5725             pntsd->osidoffset =3D 0;
> > ced2b26a76cd1d fs/cifsd/smb2pdu.c      Sebastian Gottschall      2021-0=
4-27  5726             pntsd->gsidoffset =3D 0;
> > ced2b26a76cd1d fs/cifsd/smb2pdu.c      Sebastian Gottschall      2021-0=
4-27  5727             pntsd->sacloffset =3D 0;
> > ced2b26a76cd1d fs/cifsd/smb2pdu.c      Sebastian Gottschall      2021-0=
4-27  5728             pntsd->dacloffset =3D 0;
> > ced2b26a76cd1d fs/cifsd/smb2pdu.c      Sebastian Gottschall      2021-0=
4-27  5729
> > ced2b26a76cd1d fs/cifsd/smb2pdu.c      Sebastian Gottschall      2021-0=
4-27  5730             secdesclen =3D sizeof(struct smb_ntsd);
> > ced2b26a76cd1d fs/cifsd/smb2pdu.c      Sebastian Gottschall      2021-0=
4-27  5731             rsp->OutputBufferLength =3D cpu_to_le32(secdesclen);
> > ced2b26a76cd1d fs/cifsd/smb2pdu.c      Sebastian Gottschall      2021-0=
4-27  5732
> > ced2b26a76cd1d fs/cifsd/smb2pdu.c      Sebastian Gottschall      2021-0=
4-27  5733             return 0;
> > ced2b26a76cd1d fs/cifsd/smb2pdu.c      Sebastian Gottschall      2021-0=
4-27  5734     }
> > ced2b26a76cd1d fs/cifsd/smb2pdu.c      Sebastian Gottschall      2021-0=
4-27  5735
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5736     if (work->next_smb2_rcv_hdr_off) {
> > 2d004c6cae567e fs/ksmbd/smb2pdu.c      Paulo Alcantara           2022-0=
3-21  5737             if (!has_file_id(req->VolatileFileId)) {
> > 3867369ef8f760 fs/ksmbd/smb2pdu.c      Namjae Jeon               2021-0=
7-08  5738                     ksmbd_debug(SMB, "Compound request set FID =
=3D %llu\n",
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5739                                 work->compound_fid);
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5740                     id =3D work->compound_fid;
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5741                     pid =3D work->compound_pfid;
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5742             }
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5743     }
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5744
> > 3867369ef8f760 fs/ksmbd/smb2pdu.c      Namjae Jeon               2021-0=
7-08  5745     if (!has_file_id(id)) {
> > 2d004c6cae567e fs/ksmbd/smb2pdu.c      Paulo Alcantara           2022-0=
3-21  5746             id =3D req->VolatileFileId;
> > 2d004c6cae567e fs/ksmbd/smb2pdu.c      Paulo Alcantara           2022-0=
3-21  5747             pid =3D req->PersistentFileId;
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5748     }
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5749
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5750     fp =3D ksmbd_lookup_fd_slow(work, id, pid);
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5751     if (!fp)
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5752             return -ENOENT;
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5753
> > 4609e1f18e19c3 fs/ksmbd/smb2pdu.c      Christian Brauner         2023-0=
1-13  5754     idmap =3D file_mnt_idmap(fp->filp);
> > ab0b263b749ade fs/ksmbd/smb2pdu.c      Namjae Jeon               2021-0=
6-29  5755     inode =3D file_inode(fp->filp);
> > e67fe63341b811 fs/ksmbd/smb2pdu.c      Christian Brauner         2023-0=
1-13  5756     ksmbd_acls_fattr(&fattr, idmap, inode);
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5757
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5758     if (test_share_config_flag(work->tcon->share_conf,
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5759                                KSMBD_SHARE_FLAG_ACL_XATTR))
> > 4609e1f18e19c3 fs/ksmbd/smb2pdu.c      Christian Brauner         2023-0=
1-13  5760             ppntsd_size =3D ksmbd_vfs_get_sd_xattr(work->conn, i=
dmap,
> > 8f0541186e9ad1 fs/ksmbd/smb2pdu.c      Namjae Jeon               2022-0=
8-02  5761                                                  fp->filp->f_pat=
h.dentry,
> > 8f0541186e9ad1 fs/ksmbd/smb2pdu.c      Namjae Jeon               2022-0=
8-02  5762                                                  &ppntsd);
> > 8f0541186e9ad1 fs/ksmbd/smb2pdu.c      Namjae Jeon               2022-0=
8-02  5763
> > 8f0541186e9ad1 fs/ksmbd/smb2pdu.c      Namjae Jeon               2022-0=
8-02  5764     /* Check if sd buffer size exceeds response buffer size */
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5765     max_len =3D smb2_calc_max_out_buf_len(work,
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5766                     offsetof(struct smb2_query_info_rsp, Buffer)=
,
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5767                     le32_to_cpu(req->OutputBufferLength));
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5768     if (max_len < 0) {
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5769             rc =3D -EINVAL;
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5770             goto out;
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5771     }
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5772
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5773     scratch_len =3D smb_acl_sec_desc_scratch_len(&fattr, ppntsd,
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5774                     ppntsd_size, addition_info);
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5775     pntsd =3D kvmalloc(scratch_len, KSMBD_DEFAULT_GFP);
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5776     if (!pntsd) {
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5777             rc =3D -ENOMEM;
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5778             goto out;
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5779     }
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5780
> > 4d7ca4090184c1 fs/ksmbd/smb2pdu.c      Christian Brauner         2023-0=
1-13  5781     rc =3D build_sec_desc(idmap, pntsd, ppntsd, ppntsd_size,
> > 8f0541186e9ad1 fs/ksmbd/smb2pdu.c      Namjae Jeon               2022-0=
8-02  5782                     addition_info, &secdesclen, &fattr);
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5783
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5784  out:
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5785     posix_acl_release(fattr.cf_acls);
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5786     posix_acl_release(fattr.cf_dacls);
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5787     kfree(ppntsd);
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5788     ksmbd_fd_put(work, fp);
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5789     if (rc) {
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5790             kvfree(pntsd);
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5791             return rc;
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5792     }
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5793
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5794     rsp->OutputBufferLength =3D cpu_to_le32(secdesclen);
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5795     return ksmbd_iov_pin_rsp_read(work, (void *)rsp,
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5796                     offsetof(struct smb2_query_info_rsp, Buffer)=
,
> > 095198efe2c864 fs/smb/server/smb2pdu.c Asim Viladi Oglu Manizada 2026-0=
3-16  5797                     pntsd, secdesclen);
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5798  }
> > e2f34481b24db2 fs/cifsd/smb2pdu.c      Namjae Jeon               2021-0=
3-16  5799
> >
> > :::::: The code at line 5723 was first introduced by commit
> > :::::: ced2b26a76cd1db0b6ccb39e0bc873177c9bda21 cifsd: Fix regression i=
n smb2_get_info
> >
> > :::::: TO: Sebastian Gottschall <s.gottschall@dd-wrt.com>
> > :::::: CC: Steve French <stfrench@microsoft.com>
> >
> b



--=20
Thanks,

Steve
