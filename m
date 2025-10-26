Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9214D2FFF95
	for <linux-cifs@vger.kernel.org>; Sun, 26 Oct 2025 23:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761520667; cv=none; b=T8qw3J3hX/9KKjbDqetxySdNBYFWJzme1R3s1PMxLVmMHvta5gsKfL2NMkBGWQ1m1+0cD0CqWsrSxTpT0cOlGC65NaDPkzpPoNWNlOzSY3SBe/JJG2CxRDzB0k1c2kyIgCRU2s2U8a7GA7h6ILp5HVgxHM09P0ZYW63oIN8/g3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761520667; c=relaxed/simple;
	bh=Sxn1qFboHLBHmz3scQl5x/MknSvqUBzC0WU+bHRwKBw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kzHsToi8pwEpRzlJEYunpNW33DTYewhU0WJLb1V+tv8uxTeCTsJ5Q8w7CCNHjmbd34lrW8IKUIMBXMNjOnAHRdyZQVISmdRYZTe+m5yC95yCzxDO1nsW8SSIIYoxPEuKdO2c6BH8wU3F2H9KEDtxhEFgU8rShrYcAl4zrclsjek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PB2vfHYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PB2vfHYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39891C2BCAF
	for <linux-cifs@vger.kernel.org>; Sun, 26 Oct 2025 23:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761520667;
	bh=Sxn1qFboHLBHmz3scQl5x/MknSvqUBzC0WU+bHRwKBw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PB2vfHYQQ4lPgfwvvaASjw1Nv4DWoKZo8m9FKsNnH9vHvHjCRJbojs5LEHCSSKuYY
	 u7nivXjzV25EhJT7+lo2NY3/cxjjsoIj2lbgrj6qkqrU68AopNEfKOuVTm+l4B8Xob
	 muBa6zl6VHUIiZxyEazF8nMrq3XR+XmNpBdp5DLp0I2pTcEADWdSoJM5iM05qRlsYe
	 fKhsH9bMxPPv+/l/exfh4MvxMFsuNW51BWGf+pu6Z5N/8xOemJ8lQLHgawMA+GXqib
	 24Pda9OMJOiADZff/s/1H84QKCJWrTu/eNgdiDFGzHreAMLoWMQtZAZTOKKmm/3rj3
	 TM6IIBWCYYqxQ==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b4f323cf89bso964870266b.2
        for <linux-cifs@vger.kernel.org>; Sun, 26 Oct 2025 16:17:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWcNYbXWD4QjyQjBbtIK6mna1I/unHufZ0l6wZl8pmVxlBpGdNRFffVysyyOJqDXsmO6zrnIwzhNbHf@vger.kernel.org
X-Gm-Message-State: AOJu0YwG0slOncw4qEuS7hpdvS2AOOyQ6L6P6Hc1n5VZd1MATpsYM2sq
	rRyggg9oY1u9vSCFoq9IYiyZqgJq3qHQX+MtZd7g4AEVM0KbSm4NODQ/r8a7Vpl5xPZHxfWKvrM
	pJTjm+/bQL3VFB9eHsXrsK53zb4nYgNE=
X-Google-Smtp-Source: AGHT+IHPeTtq5sY0zSRj4xzG9FTc1LgV1Sh+fv9mm7ksb1Ngm9o67tVpEeeEvXIAUOh6I0kgYNEo/9S0jp89gDsI/qc=
X-Received: by 2002:a05:6402:2113:b0:637:ee5f:d89e with SMTP id
 4fb4d7f45d1cf-63c1f6b4c29mr33882365a12.20.1761520665599; Sun, 26 Oct 2025
 16:17:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251014071917.3004573-8-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd9SJ_92si7_wt=hLm9RZmrVm2oZZqNOPFDGvPZzMzkAYA@mail.gmail.com> <e2757988-63af-4ace-aed7-f8708f52fe93@linux.dev>
In-Reply-To: <e2757988-63af-4ace-aed7-f8708f52fe93@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 27 Oct 2025 08:17:33 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-ZuVzN9zFLtdmm7Kzh_wYUV_vAj4G=-evw80rLmBrrdQ@mail.gmail.com>
X-Gm-Features: AWmQ_bnk1otU24Jjp9_bBp7PYBfUXhIordxU-QA7NcUtWLaVpKu341C-ujpzuc8
Message-ID: <CAKYAXd-ZuVzN9zFLtdmm7Kzh_wYUV_vAj4G=-evw80rLmBrrdQ@mail.gmail.com>
Subject: Re: [PATCH v3 07/22] smb: move some duplicate definitions to common/smb2pdu.h
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: stfrench@microsoft.com, metze@samba.org, pali@kernel.org, 
	smfrench@gmail.com, sfrench@samba.org, senozhatsky@chromium.org, 
	tom@talpey.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, bharathsm@microsoft.com, christophe.jaillet@wanadoo.fr, 
	zhangguodong@kylinos.cn, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 26, 2025 at 6:21=E2=80=AFPM ChenXiaoSong
<chenxiaosong.chenxiaosong@linux.dev> wrote:
>
> Hi Namjae,
Hi Chen,
>
> I'm confused by what this sentence means: "I prefer moving it when the
> durable handle structures are moved to /common later.".
>
> What does "it" refer to? Does "it" refer to the whole patch, or only to
> "SMB2_DHANDLE_FLAG_PERSISTENT"?
Only SMB2_DHANDLE_FLAG_PERSISTENT.

Thanks!
>
> On 10/20/25 12:52 PM, Namjae Jeon wrote:
> > On Tue, Oct 14, 2025 at 4:21=E2=80=AFPM <chenxiaosong.chenxiaosong@linu=
x.dev> wrote:
> >>
> >> From: ZhangGuoDong <zhangguodong@kylinos.cn>
> >>
> >> In order to maintain the code more easily, move duplicate definitions =
to
> >> new common header file.
> >>
> >> Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
> >> ---
> >>   fs/smb/client/smb2pdu.h | 24 +++---------------------
> >>   fs/smb/common/smb2pdu.h | 24 ++++++++++++++++++++++++
> >>   fs/smb/server/smb2pdu.c |  8 ++++----
> >>   fs/smb/server/smb2pdu.h | 17 -----------------
> >>   4 files changed, 31 insertions(+), 42 deletions(-)
> >>
> >> diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
> >> index 101024f8f725..c013560bcfa1 100644
> >> --- a/fs/smb/client/smb2pdu.h
> >> +++ b/fs/smb/client/smb2pdu.h
> >> @@ -135,11 +135,9 @@ struct share_redirect_error_context_rsp {
> >>
> >>
> >>   /* See MS-SMB2 2.2.13.2.11 */
> >> -/* Flags */
> >> -#define SMB2_DHANDLE_FLAG_PERSISTENT   0x00000002
> >>   struct durable_context_v2 {
> >>          __le32 Timeout;
> >> -       __le32 Flags;
> >> +       __le32 Flags; /* see SMB2_DHANDLE_FLAG_PERSISTENT */
> >>          __u64 Reserved;
> >>          __u8 CreateGuid[16];
> >>   } __packed;
> >> @@ -157,13 +155,13 @@ struct durable_reconnect_context_v2 {
> >>                  __u64 VolatileFileId;
> >>          } Fid;
> >>          __u8 CreateGuid[16];
> >> -       __le32 Flags; /* see above DHANDLE_FLAG_PERSISTENT */
> >> +       __le32 Flags; /* see SMB2_DHANDLE_FLAG_PERSISTENT */
> >>   } __packed;
> >>
> >>   /* See MS-SMB2 2.2.14.2.12 */
> >>   struct durable_reconnect_context_v2_rsp {
> >>          __le32 Timeout;
> >> -       __le32 Flags; /* see above DHANDLE_FLAG_PERSISTENT */
> >> +       __le32 Flags; /* see SMB2_DHANDLE_FLAG_PERSISTENT */
> >>   } __packed;
> >>
> >>   struct create_durable_handle_reconnect_v2 {
> >> @@ -263,22 +261,6 @@ struct network_resiliency_req {
> >>   } __packed;
> >>   /* There is no buffer for the response ie no struct network_resilien=
cy_rsp */
> >>
> >> -#define RSS_CAPABLE    cpu_to_le32(0x00000001)
> >> -#define RDMA_CAPABLE   cpu_to_le32(0x00000002)
> >> -
> >> -#define INTERNETWORK   cpu_to_le16(0x0002)
> >> -#define INTERNETWORKV6 cpu_to_le16(0x0017)
> >> -
> >> -struct network_interface_info_ioctl_rsp {
> >> -       __le32 Next; /* next interface. zero if this is last one */
> >> -       __le32 IfIndex;
> >> -       __le32 Capability; /* RSS or RDMA Capable */
> >> -       __le32 Reserved;
> >> -       __le64 LinkSpeed;
> >> -       __le16 Family;
> >> -       __u8 Buffer[126];
> >> -} __packed;
> >> -
> >>   struct iface_info_ipv4 {
> >>          __be16 Port;
> >>          __be32 IPv4Address;
> >> diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
> >> index f79a5165a7cc..25e8ece283c4 100644
> >> --- a/fs/smb/common/smb2pdu.h
> >> +++ b/fs/smb/common/smb2pdu.h
> >> @@ -1290,6 +1290,10 @@ struct create_mxac_req {
> >>          __le64 Timestamp;
> >>   } __packed;
> >>
> >> +/* See MS-SMB2 2.2.13.2.11 and MS-SMB2 2.2.13.2.12 and MS-SMB2 2.2.14=
.2.12 */
> >> +/* Flags */
> >> +#define SMB2_DHANDLE_FLAG_PERSISTENT   0x00000002
> > I prefer moving it when the durable handle structures are moved to
> > /common later.
> > Thanks.
>
> --
> Thanks,
> ChenXiaoSong.
>
>
