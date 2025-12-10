Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E2622301
	for <linux-cifs@vger.kernel.org>; Wed, 10 Dec 2025 00:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765326700; cv=none; b=mdhDVead0JYl2jnCGYy1gCf/TSDmuL6H/x5nGV9XZfocLroWcadWQQlXKyMOKm3nq4l8mLx1K6fIw/E18TKlV13XUku6Cr0aNlzU9hI9EWu2ZMLCotJeVppgFjl9rwa5pS5sYt3pRvyi1MfDjjS6XgVJEoGkNSUAmYKowL7M7Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765326700; c=relaxed/simple;
	bh=nHeuKtIbOtLjfBuEE3xneTd56k52gly39lGm3e+xxao=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h6Y7hxs6vKdPlUQ+SIitCDwd117U73WO4QpPlQYqjIDSBwjhx+5JMpvYsenT4TAYWeN8ZBGviVHn399g2pxNmzxcx4MHe1t1tg+EfprzGFZew6KMLyiLliHi9JHCN/q0Wyo49TLqyts9GWek5KeDyull5URbfi3JScnoZPQrPts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XISDicUR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XISDicUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7782EC19423
	for <linux-cifs@vger.kernel.org>; Wed, 10 Dec 2025 00:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765326700;
	bh=nHeuKtIbOtLjfBuEE3xneTd56k52gly39lGm3e+xxao=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XISDicURaJo0hHgoz/xxMZ4U6/rsm2i4UdWpA5GxaSenwA7NsQ4Sn6qW8+D5sh6P/
	 gV7HEVO/yiM2ldZ5P3QM8dHCvr+HAT0KZZ92++AM3ow3RP4CeoCuwqZP7mM6Bf707/
	 q7CMfc4uyX5fPx0fTs/43AZB4h1j/JSRGSC86RUEdvDa/VfUw09+Mp3HycOMljNEQt
	 0LhSi7K6zo9c7t7HZqoPcxYoVsTtO2CcsR1YWoAqTeagU3AcCOEVz1JEXE0ildprUI
	 OVJ/O1pN3hPri31OQBnQvXrWwqiVZDfKiZtyYHA6uRVjVZoFNUmTxfib0FVg+/wa6N
	 cQWd/ht5es8pQ==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6419b7b4b80so8941786a12.2
        for <linux-cifs@vger.kernel.org>; Tue, 09 Dec 2025 16:31:40 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVBHtpeI7trVLOfwL3XJF0K30iGdpakwswSfnzx5m1At96Wa9h8Xu6VlprlxAN4Z8XgJTcvCsuDbjWf@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+I1DWd1K9ZTVOruY/tfpJBVhzKcOMutJQ8JJMV+Uv8VuL5rve
	Vh1zTqNXhBov55eworURvO6E8V8E7RPD20OmAMFTaic0gPAjZO7wU9IQpsIHn3YQkZ45UNzLaMb
	cFRMqY1az9dzVn63Fjx50dsZOjehwJCk=
X-Google-Smtp-Source: AGHT+IFui/1rB9ieu08NeB5B44pZSjwv4RPzrAUmlEqEUSRuhSyvAPqw4ZfKA7yRQhXTnOMDYrYpMQaraKumNWvIzEU=
X-Received: by 2002:a05:6402:5215:b0:649:5bb4:59e5 with SMTP id
 4fb4d7f45d1cf-6496d5c8b2cmr736993a12.30.1765326698933; Tue, 09 Dec 2025
 16:31:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251209011020.3270989-12-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd8so+qB4zAXmj2mNSxqQ4emJe6eqhg-UgpKYgP+URk_yA@mail.gmail.com> <c153bfca-4b19-4ffe-8c65-21a0b87263fa@linux.dev>
In-Reply-To: <c153bfca-4b19-4ffe-8c65-21a0b87263fa@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 10 Dec 2025 09:31:26 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8ANQKPbzzxfhp1eiH5my-uoZvr-x0iRYaqu=+BnV0P8A@mail.gmail.com>
X-Gm-Features: AQt7F2qClwUyUa1fB6KXLI8ExAZESR7OV1MZVJpRtkYrcK951qLqtwzU6IXtHpE
Message-ID: <CAKYAXd8ANQKPbzzxfhp1eiH5my-uoZvr-x0iRYaqu=+BnV0P8A@mail.gmail.com>
Subject: Re: [PATCH 11/13] smb: introduce struct create_posix_ctxt_rsp
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	liuzhengyuan@kylinos.cn, huhai@kylinos.cn, liuyun01@kylinos.cn, 
	ZhangGuoDong <zhangguodong@kylinos.cn>, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 10, 2025 at 9:13=E2=80=AFAM ChenXiaoSong
<chenxiaosong.chenxiaosong@linux.dev> wrote:
>
> Hi Namjae,
>
> The `create_posix_rsp` structures on the client and server sides differ,
> but they share a common part, and only this common part is defined in
> POSIX=E2=80=91SMB2 2.2.14.2.16.
I agree with moving create_posix_rsp struct to common, but doing it
partially feels forced and unnatural.
>
> /*
>   * [POSIX-SMB2] SMB3 POSIX Extensions
>   * Link:
> https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/smb3_posix_ex=
tensions.md
>   */
>
> Thanks,
> ChenXiaoSong.
>
> On 12/10/25 7:45 AM, Namjae Jeon wrote:
> > On Tue, Dec 9, 2025 at 10:12=E2=80=AFAM <chenxiaosong.chenxiaosong@linu=
x.dev> wrote:
> >>
> >> From: ZhangGuoDong <zhangguodong@kylinos.cn>
> >>
> >> Modify the following places:
> >>
> >>    - introduce new struct create_posix_ctxt_rsp
> >>    - some fields in "struct create_posix_rsp" -> "struct create_posix_=
ctxt_rsp"
> >>    - create_posix_rsp_buf(): offsetof(..., nlink) -> offsetof(..., ctx=
t_rsp)
> > I don't know why we need to add a new create_posix_ctxt_rsp struct.
> >>
> >> Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
> >> ---
> >>   fs/smb/client/smb2pdu.c |  9 +++++----
> >>   fs/smb/client/smb2pdu.h |  6 ++----
> >>   fs/smb/common/smb2pdu.h | 18 ++++++++++++++++++
> >>   fs/smb/server/oplock.c  |  8 ++++----
> >>   fs/smb/server/smb2pdu.h |  6 ++----
> >>   5 files changed, 31 insertions(+), 16 deletions(-)
> >>
> >> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> >> index ef2c6ac500f7..ec0f83db5591 100644
> >> --- a/fs/smb/client/smb2pdu.c
> >> +++ b/fs/smb/client/smb2pdu.c
> >> @@ -2298,9 +2298,9 @@ parse_posix_ctxt(struct create_context *cc, stru=
ct smb2_file_all_info *info,
> >>
> >>          memset(posix, 0, sizeof(*posix));
> >>
> >> -       posix->nlink =3D le32_to_cpu(*(__le32 *)(beg + 0));
> >> -       posix->reparse_tag =3D le32_to_cpu(*(__le32 *)(beg + 4));
> >> -       posix->mode =3D le32_to_cpu(*(__le32 *)(beg + 8));
> >> +       posix->ctxt_rsp.nlink =3D le32_to_cpu(*(__le32 *)(beg + 0));
> >> +       posix->ctxt_rsp.reparse_tag =3D le32_to_cpu(*(__le32 *)(beg + =
4));
> >> +       posix->ctxt_rsp.mode =3D le32_to_cpu(*(__le32 *)(beg + 8));
> >>
> >>          sid =3D beg + 12;
> >>          sid_len =3D posix_info_sid_size(sid, end);
> >> @@ -2319,7 +2319,8 @@ parse_posix_ctxt(struct create_context *cc, stru=
ct smb2_file_all_info *info,
> >>          memcpy(&posix->group, sid, sid_len);
> >>
> >>          cifs_dbg(FYI, "nlink=3D%d mode=3D%o reparse_tag=3D%x\n",
> >> -                posix->nlink, posix->mode, posix->reparse_tag);
> >> +                posix->ctxt_rsp.nlink, posix->ctxt_rsp.mode,
> >> +                posix->ctxt_rsp.reparse_tag);
> >>   }
> >>
> >>   int smb2_parse_contexts(struct TCP_Server_Info *server,
> >> diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
> >> index 78bb99f29d38..4928fb620233 100644
> >> --- a/fs/smb/client/smb2pdu.h
> >> +++ b/fs/smb/client/smb2pdu.h
> >> @@ -251,11 +251,9 @@ struct smb2_file_id_extd_directory_info {
> >>
> >>   extern char smb2_padding[7];
> >>
> >> -/* equivalent of the contents of SMB3.1.1 POSIX open context response=
 */
> >> +/* See POSIX-SMB2 2.2.14.2.16 */
> >>   struct create_posix_rsp {
> >> -       u32 nlink;
> >> -       u32 reparse_tag;
> >> -       u32 mode;
> >> +       struct create_posix_ctxt_rsp ctxt_rsp;
> >>          struct smb_sid owner; /* var-sized on the wire */
> >>          struct smb_sid group; /* var-sized on the wire */
> >>   } __packed;
> >> diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
> >> index 72f2cfc47da8..698ab9d7d16b 100644
> >> --- a/fs/smb/common/smb2pdu.h
> >> +++ b/fs/smb/common/smb2pdu.h
> >> @@ -1814,4 +1814,22 @@ typedef struct smb_negotiate_req {
> >>          unsigned char DialectsArray[];
> >>   } __packed SMB_NEGOTIATE_REQ;
> >>
> >> +
> >> +/*
> >> + * [POSIX-SMB2] SMB3 POSIX Extensions
> >> + * Link: https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/=
smb3_posix_extensions.md
> >> + */
> >> +
> >> +/*
> >> + * SMB2_CREATE_POSIX_CONTEXT Response
> >> + * See POSIX-SMB2 2.2.14.2.16
> >> + */
> >> +struct create_posix_ctxt_rsp {
> >> +       __le32 nlink;
> >> +       __le32 reparse_tag;
> >> +       __le32 mode;
> >> +       // var sized owner SID
> >> +       // var sized group SID
> >> +} __packed;
> >> +
> >>   #endif                         /* _COMMON_SMB2PDU_H */
> >> diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
> >> index 1f07ebf431d7..8658402ff893 100644
> >> --- a/fs/smb/server/oplock.c
> >> +++ b/fs/smb/server/oplock.c
> >> @@ -1703,7 +1703,7 @@ void create_posix_rsp_buf(char *cc, struct ksmbd=
_file *fp)
> >>          buf =3D (struct create_posix_rsp *)cc;
> >>          memset(buf, 0, sizeof(struct create_posix_rsp));
> >>          buf->ccontext.DataOffset =3D cpu_to_le16(offsetof
> >> -                       (struct create_posix_rsp, nlink));
> >> +                       (struct create_posix_rsp, ctxt_rsp));
> >>          /*
> >>           * DataLength =3D nlink(4) + reparse_tag(4) + mode(4) +
> >>           * domain sid(28) + unix group sid(16).
> >> @@ -1730,9 +1730,9 @@ void create_posix_rsp_buf(char *cc, struct ksmbd=
_file *fp)
> >>          buf->Name[14] =3D 0xCD;
> >>          buf->Name[15] =3D 0x7C;
> >>
> >> -       buf->nlink =3D cpu_to_le32(inode->i_nlink);
> >> -       buf->reparse_tag =3D cpu_to_le32(fp->volatile_id);
> >> -       buf->mode =3D cpu_to_le32(inode->i_mode & 0777);
> >> +       buf->ctxt_rsp.nlink =3D cpu_to_le32(inode->i_nlink);
> >> +       buf->ctxt_rsp.reparse_tag =3D cpu_to_le32(fp->volatile_id);
> >> +       buf->ctxt_rsp.mode =3D cpu_to_le32(inode->i_mode & 0777);
> >>          /*
> >>           * SidBuffer(44) contain two sids(Domain sid(28), UNIX group =
sid(16)).
> >>           * Domain sid(28) =3D revision(1) + num_subauth(1) + authorit=
y(6) +
> >> diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
> >> index 66cdc8e4a648..09311a9eb1de 100644
> >> --- a/fs/smb/server/smb2pdu.h
> >> +++ b/fs/smb/server/smb2pdu.h
> >> @@ -83,13 +83,11 @@ struct create_durable_rsp {
> >>          } Data;
> >>   } __packed;
> >>
> >> -/* equivalent of the contents of SMB3.1.1 POSIX open context response=
 */
> >> +/* See POSIX-SMB2 2.2.14.2.16 */
> >>   struct create_posix_rsp {
> >>          struct create_context_hdr ccontext;
> >>          __u8    Name[16];
> >> -       __le32 nlink;
> >> -       __le32 reparse_tag;
> >> -       __le32 mode;
> >> +       struct create_posix_ctxt_rsp ctxt_rsp;
> >>          /* SidBuffer contain two sids(Domain sid(28), UNIX group sid(=
16)) */
> >>          u8 SidBuffer[44];
> >>   } __packed;
> >> --
> >> 2.43.0
> >>
>
