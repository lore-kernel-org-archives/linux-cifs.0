Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NMDTjVkT"
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4702DC1
	for <linux-cifs@vger.kernel.org>; Mon, 27 Nov 2023 21:20:22 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-5c194b111d6so3805130a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 27 Nov 2023 21:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701148821; x=1701753621; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5BGrTwTsyS7NBuZTQigvvPInSB8iz4TgT2/Lb29b0gg=;
        b=NMDTjVkTe04HMURWHBFkqxnOJN8GLYsSFglU4JyxRJ+oTVf7pc4rlZN/lwN0Obgqq2
         XyCNP3HjlJ+8wa4lAxh6qkLVQEkyacRRhy2giOabazTXX2pOF++4OQ2Fuhb+y+OeR9PR
         7JzbvRXMdm8XjRkzD3R9UN1H/qVElhDPLkGZUlxx1tilKBumdJfF6qHh4Zg3OXJfw2Wm
         FOUmk06QMF+X78TdpDqFEbRob4JcFx0U9bdUY8Ak/P9SnMkOVYDG3XKo9NtRX94gSkr/
         yaAReO4ORESoMgCecvl3AlCLGjFKhBN5q6wMV+xrlQf0TvCVaHdYsL2V71cbKWZueSSb
         JPZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701148821; x=1701753621;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5BGrTwTsyS7NBuZTQigvvPInSB8iz4TgT2/Lb29b0gg=;
        b=SNLgBX4uM1tlbLIAKqYnfCyol5oTGrXnTZU4/H/N78rXSveUxA1SOB0154Hr7UC3dW
         6duXkyY2iFpGWZjD+8psJnxw9nKsxG3ZxJZ3xHTtQeslBtq1/CI0t9n8SY9eTPV2+DD+
         vRxW7aWEaG6hzY8XRv+8TGV2d3SLG69DylFYrPjpPAzeHT5avmhIIFRBXeyRGU+2fxGx
         axJFoWczdVevg8YBv3KSZ6Te3kepBRiADCMNsuvn8MHFsl16mrMv4vK0qLtqd2dewzS/
         jaH0It0ZB2Ak0AHEPcr7LXDgspn/qvxQ+4g023wxKkq/T1AL7oSDToeNXqpRL/DAt3oV
         GG6g==
X-Gm-Message-State: AOJu0Yw6YBeAh9jwGTfaYLRO5bynx8+Oo4LHXl0akndtv74k7anf7thN
	warINB1HUc/MhpYSLlLIF8Y=
X-Google-Smtp-Source: AGHT+IFxrS3QLl0IeHJBBzeOonePvCkMN/BlU9I2RoygRyXFyEjVgcaOiuRikPQ0tvY1F7ChZONUhw==
X-Received: by 2002:a05:6a20:3d11:b0:18c:9855:e949 with SMTP id y17-20020a056a203d1100b0018c9855e949mr6742177pzi.15.1701148821633;
        Mon, 27 Nov 2023 21:20:21 -0800 (PST)
Received: from debian (c-73-109-30-110.hsd1.wa.comcast.net. [73.109.30.110])
        by smtp.gmail.com with ESMTPSA id gx1-20020a17090b124100b0027e289ac436sm8198601pjb.8.2023.11.27.21.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 21:20:21 -0800 (PST)
Date: Mon, 27 Nov 2023 21:20:19 -0800
From: Pierre Mariani <pierre.mariani@gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH 1/4] smb: client: Delete unused value
Message-ID: <ZWV4k-HP7rYOo-Ky@debian>
References: <b9f9f617abc69d0a7ddb3109bc257073c8b165de.1701060106.git.pierre.mariani@gmail.com>
 <CAH2r5mujUZgEiHJZgo-6Z6Xe3xykWMqUoTvQ8_ev__5-5RmO3w@mail.gmail.com>
 <ZWQl2yN7iOpKegcJ@debian>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZWQl2yN7iOpKegcJ@debian>

On Sun, Nov 26, 2023 at 09:15:07PM -0800, Pierre Mariani wrote:
> On Sun, Nov 26, 2023 at 10:54:38PM -0600, Steve French wrote:
> > on this one - I lean toward leaving it in (although technically
> > unused) since may reduce future errors by being clear that this is not
> > an error case and may be a bit clearer to read to some.  No strong
> > opinion though on this.
> > 
> 
> I will undo this change and update the Coverity triage data instead.

I will not be able to make updates to Coverity until I get contributor access,
which will happen if and when one of my patches gets merged. I will update
Coverity whenever it becomes possible.

I have undone the change and submitted a v2 patch set.

> 
> > On Sun, Nov 26, 2023 at 10:52 PM Pierre Mariani
> > <pierre.mariani@gmail.com> wrote:
> > >
> > > rc does not need to be set to any value in this location as it gets set to other
> > > values is all subsequent logical branches before being used.
> > > Fixes Coverity 1562035 Unused value.
> > >
> > > Signed-off-by: Pierre Mariani <pierre.mariani@gmail.com>
> > > ---
> > >  fs/smb/client/connect.c | 1 -
> > >  1 file changed, 1 deletion(-)
> > >
> > > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > > index f896f60c924b..449d56802692 100644
> > > --- a/fs/smb/client/connect.c
> > > +++ b/fs/smb/client/connect.c
> > > @@ -1770,7 +1770,6 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
> > >                         tcp_ses, (struct sockaddr *)&ctx->dstaddr);
> > >                 if (tcp_ses->smbd_conn) {
> > >                         cifs_dbg(VFS, "RDMA transport established\n");
> > > -                       rc = 0;
> > >                         goto smbd_connected;
> > >                 } else {
> > >                         rc = -ENOENT;
> > > --
> > > 2.39.2
> > >
> > 
> > 
> > -- 
> > Thanks,
> > 
> > Steve
