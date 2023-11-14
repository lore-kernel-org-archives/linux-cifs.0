Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018972E829
	for <linux-cifs@vger.kernel.org>; Tue, 14 Nov 2023 22:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FG2g45Cv"
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59238DA
	for <linux-cifs@vger.kernel.org>; Tue, 14 Nov 2023 14:07:00 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-507bd644a96so8801558e87.3
        for <linux-cifs@vger.kernel.org>; Tue, 14 Nov 2023 14:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699999618; x=1700604418; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ig7nGcUFXULRasi3NAtxUPJlQy8IdLpX1DNTFIjiLPY=;
        b=FG2g45CvIKRsHxWoMSQXhLqiOGdSMZjCeNV1DpRlxAHMIMnwatLTVR9S2vMFCD9Xq6
         MimV4Fok0BdnHbeT109wjrD4DjmqDZsDVUf8RVl9RgYcYneaF4BBhU2C9pFI8X3FhS0K
         WO7jaiRyCGLTLf6qyJTvrXOPefsTnZlOpJKJdD16OSk6j8M82eG3hkNzxHumugdeo7o/
         cUWfPJsvICtsFuymeZX0HNnu1smMB/+hyXFiq9vQxKLAINnorccLbQ09soUs6VSVt/gx
         MwnFW+aPakQ/lAezHAifqoOHIWmwVpkbON+04v8B/IV95R8ZaoZJuVVI1hBX6TwaC/Mj
         CapA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699999618; x=1700604418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ig7nGcUFXULRasi3NAtxUPJlQy8IdLpX1DNTFIjiLPY=;
        b=UrkOgHe02sOCAn2BSAPz7CS+/8EkU9/uszj7C5CFhA4FCPuMOBY3410fc33NY/RCcx
         EhZ9RX9JNnB8p77B5VuEzQEFve4Iar4Pl+GwL9NsgGeC8rL3va0Yito9fgswKWlIIPEz
         V+05Nhw+O6Eeia9cXQ9d1QC14oHkvwi4xDpKqUTEQ0ThqqsrjBu4Vb6/B5xFFFkKsp6P
         W+EjxIuEIiWx6fgnCCqtSD40/v4njskx7zJ3CSdKXHPwemS5KjTg/ieUHRSxEWAJFsPO
         Z0jh017m0R9tyKlLJ0Zg1oWfQWXu+vLfvHBf5jcd33bcddFlu2eG9hZ33a7y1VT/b0at
         DOJQ==
X-Gm-Message-State: AOJu0Yx7czAST4jdt2f/dUr52wNcYBXIMeKLVf3S41VWZcq3ILmuMIsw
	fbOPRLjboPOpvAZm9ZlMSuThABov7GPOcRAA+1E=
X-Google-Smtp-Source: AGHT+IHhMUylOscV3RSc4mO6tATPNHnpG6YKx+wzeWTYl+dPiiu7xTwC+M6kMWRLCVOobKXOyIRZfvYv3dN4yLcmy2w=
X-Received: by 2002:a19:6509:0:b0:507:b099:749d with SMTP id
 z9-20020a196509000000b00507b099749dmr7316301lfb.15.1699999618162; Tue, 14 Nov
 2023 14:06:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADCRUiNvZuiUZ0VGZZO9HRyPyw6x92kiA7o7Q4tsX5FkZqUkKg@mail.gmail.com>
 <d2c0c53db617b6d2f9b71e734b165b4b.pc@manguebit.com> <CADCRUiNSk7b7jVQrYoD153UmaBdFzpcA1q3DvfwJcNC6Q=gy0w@mail.gmail.com>
 <482ee449a063acf441b943346b85e2d0.pc@manguebit.com> <CADCRUiN=tz85t5T00H1RbmwSj_35j9vbe92TaKUrESUyNSK9QA@mail.gmail.com>
In-Reply-To: <CADCRUiN=tz85t5T00H1RbmwSj_35j9vbe92TaKUrESUyNSK9QA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 14 Nov 2023 16:06:46 -0600
Message-ID: <CAH2r5mviYaW1qDW9+tqJLDv1ZCnGrgiGJ3kNMWPJBxx=UU+8Tg@mail.gmail.com>
Subject: Re: Unexpected additional umh-based DNS lookup in 6.6.0
To: Eduard Bachmakov <e.bachmakov@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> can this be proposed for the next 6.6 point release?

I don't see any updates to the 6.6.x stable tree in the last week -
but since this patch is tagged for stable (and has "Fixes:" tag as
well).  It is likely to be picked up automatically.   When next update
to 6.6 stable tree is made (to include recent merge window patches),
hopefully by Monday - we should recheck.

On Tue, Nov 14, 2023 at 4:00=E2=80=AFPM Eduard Bachmakov <e.bachmakov@gmail=
.com> wrote:
>
> I noticed this got pulled into 6.7. Given this is a user-facing
> regression, can this be proposed for the next 6.6 point release?
> Sorry, if this is already the case and I missed it.
>
> On Thu, Nov 9, 2023 at 6:29=E2=80=AFPM Paulo Alcantara <pc@manguebit.com>=
 wrote:
> >
> > Eduard Bachmakov <e.bachmakov@gmail.com> writes:
> >
> > > I don't see is_dfs_mount() being called so in my scenario we're simpl=
y
> > > relying on kzalloc initializing dfs_automount to false.
> >
> > It's expected.  If your share is DFS and client finds a DFS link or
> > reparse mount point, the dentry set for automount will get mounted with
> > new fs context where where @dfs_automount will be set.
>
> I see, thanks.
>


--=20
Thanks,

Steve
