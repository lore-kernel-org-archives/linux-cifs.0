Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JOmFu+9+"
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D9ED0
	for <linux-cifs@vger.kernel.org>; Sun, 26 Nov 2023 21:16:31 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1ce656b9780so27093995ad.2
        for <linux-cifs@vger.kernel.org>; Sun, 26 Nov 2023 21:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701062190; x=1701666990; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=akrqUlZPibOMEdsHjK0nlJK261YUG4X54J2v+jDfVe8=;
        b=JOmFu+9+GJZAxckf4nOo8jsht6VmboXAqeNfiVivU2z23Loqph4MEs4eM7DSZwfMNn
         t3oeax128S+Ia+5NBfr/tgI0LP9e0K4Suz69/1KHRuNxyNx4ihleU86NRrc1fXDtoLbT
         TLyYhcJmjg6+2HydApJt/wTJfeqjqdYbxNV97l0zev7ghxfBYcJZUik+uq0lKe8fpmrn
         PEVVl0SoWRPC/MYKStJ7YdyANiQlMK1zG3gAoDpjJdIQ/ZF9avI6MhwXdajQSnvANNh9
         vXJ0Ap+GBbaSFFGVAyraG9DY8lSNmL3CMmE6QAzccdLaQ2UGVUnvWjO4ls8ZI5VCobB/
         z2aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701062190; x=1701666990;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=akrqUlZPibOMEdsHjK0nlJK261YUG4X54J2v+jDfVe8=;
        b=r6bLBQ4ohVCAdN6IZUQ3JYAv5daYZL4hXe86q6379pcNGlWzwQTNQHpP5uzg+MT13i
         BpcKhnrINfB/W6PRVULQorcJug4N421akmdqXe1PV+uJG4VLoDV/z0KvR07W5XoOzKTr
         MCE2pauqUBRK9hSXmcaGtc47pLSj+FnQ8TD2T5Aqhhf+zaYxWI4LfBXDP8lFXNDtkf97
         42qb8cRC1HYwJ2pqLk08TGaAQWNd33F8EmumWilMbnlhx3geGNgLNsufnH/5yXzNDJYT
         Sun9Hijh662fnHAlS2ghjdeeeG7JQTVLOfgLgNjiFAhyKIa1s+umUD3D3/LDaks+shps
         3K/A==
X-Gm-Message-State: AOJu0YxQVkGNGRn+YzGEWzu+8TZTF6kmuP98maKMoWVkCt7k9ehuI0y5
	QfVBZSnHFjUj7d9qo+cPlvs=
X-Google-Smtp-Source: AGHT+IH8Bml8/7fbnqw46AELMvVk6OaWBojzdODHwv2STY5koZHov009o3REVB7ZQga5CnSnAM15wQ==
X-Received: by 2002:a17:903:32d1:b0:1cc:2091:150f with SMTP id i17-20020a17090332d100b001cc2091150fmr11390168plr.1.1701062190479;
        Sun, 26 Nov 2023 21:16:30 -0800 (PST)
Received: from debian (c-73-109-30-110.hsd1.wa.comcast.net. [73.109.30.110])
        by smtp.gmail.com with ESMTPSA id q8-20020a17090311c800b001cf57ea953csm7233028plh.290.2023.11.26.21.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Nov 2023 21:16:30 -0800 (PST)
Date: Sun, 26 Nov 2023 21:15:07 -0800
From: Pierre Mariani <pierre.mariani@gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH 1/4] smb: client: Delete unused value
Message-ID: <ZWQl2yN7iOpKegcJ@debian>
References: <b9f9f617abc69d0a7ddb3109bc257073c8b165de.1701060106.git.pierre.mariani@gmail.com>
 <CAH2r5mujUZgEiHJZgo-6Z6Xe3xykWMqUoTvQ8_ev__5-5RmO3w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mujUZgEiHJZgo-6Z6Xe3xykWMqUoTvQ8_ev__5-5RmO3w@mail.gmail.com>

On Sun, Nov 26, 2023 at 10:54:38PM -0600, Steve French wrote:
> on this one - I lean toward leaving it in (although technically
> unused) since may reduce future errors by being clear that this is not
> an error case and may be a bit clearer to read to some.  No strong
> opinion though on this.
> 

I will undo this change and update the Coverity triage data instead.

> On Sun, Nov 26, 2023 at 10:52 PM Pierre Mariani
> <pierre.mariani@gmail.com> wrote:
> >
> > rc does not need to be set to any value in this location as it gets set to other
> > values is all subsequent logical branches before being used.
> > Fixes Coverity 1562035 Unused value.
> >
> > Signed-off-by: Pierre Mariani <pierre.mariani@gmail.com>
> > ---
> >  fs/smb/client/connect.c | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > index f896f60c924b..449d56802692 100644
> > --- a/fs/smb/client/connect.c
> > +++ b/fs/smb/client/connect.c
> > @@ -1770,7 +1770,6 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
> >                         tcp_ses, (struct sockaddr *)&ctx->dstaddr);
> >                 if (tcp_ses->smbd_conn) {
> >                         cifs_dbg(VFS, "RDMA transport established\n");
> > -                       rc = 0;
> >                         goto smbd_connected;
> >                 } else {
> >                         rc = -ENOENT;
> > --
> > 2.39.2
> >
> 
> 
> -- 
> Thanks,
> 
> Steve
