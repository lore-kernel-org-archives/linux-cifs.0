Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M9HHlxME"
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8089A1A8
	for <linux-cifs@vger.kernel.org>; Wed, 29 Nov 2023 16:30:57 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-35ce9b51c8dso828015ab.0
        for <linux-cifs@vger.kernel.org>; Wed, 29 Nov 2023 16:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701304257; x=1701909057; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OMW2k7a8Rg/MkapE+DlwVbMzhcOln7ctK4UnjsMFKTs=;
        b=M9HHlxMExaS1m0RftGkYqug7NPQrdVx+e3m1+CRyuNBxXHgr0phUs+O8o1H2ozLFEG
         FLvpNhpQaWvm0CMm/PKF3njCiJGpfo5kUYDrayeurFwiqEFbo65GcfwMQZMaU+jhxx2m
         21aTj5km1ARtHG59oqyyZ8U8krSotf+XSUa6TE2UhCgaD33t5WFmyOrZMMKYyXf7LOQc
         5brdAwHAVs+MI6iVd6QijvgdYXyxBY3KgOHykVZv/MWaOWE/fQUep7E5ukyC9KqA4+dI
         Knr4oBbfqZCQ4M1uX/SL+WAmRYFRNvuvLQ6YL4z4ASRweHB4j5n2U06ghlx4YR4C8wya
         vekA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701304257; x=1701909057;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OMW2k7a8Rg/MkapE+DlwVbMzhcOln7ctK4UnjsMFKTs=;
        b=cFqMPwMgscoHeefrM34EGXDc7apEsLT/FTCC1lIbQt9H4yIAdiUxBRqePFjM9y84qy
         53rjsHhEI7luBautysc6kbNR09BhpPicXa8ldac4v3HHvRbJR+2q2LH9UEEv/yDKAdx9
         UnW8t6lgZc85iNPrv9z/mTqUx3nORmNjDJhrzqjSKVn64ylobPKh0Bdq9b/mtBW/Be+q
         n7SL3E88sXxX5iUm+iMuLfLXJsM7ZsWeyfz7Nq9ewn/+o2aEdP7jGGULHnPdzp2PhF9U
         yAxuRofYfwwku4DL6r9wfUjSPrqAp1IRaWViUqttB2PlG1Xe9I0jOty/jxDG8Y0YNMZc
         J7/w==
X-Gm-Message-State: AOJu0YzeBxk088QxNPrShRB0NNMG9kzcIOry+gvwKwRkV+7Wq32eRFQ5
	PR9hI/2oL6vpZss143n9pRY=
X-Google-Smtp-Source: AGHT+IEMPvxwFK/i8MmQSpek/LbK6VFQ5V87H+UNGgD0FvltXqDq1ZakwLBfYXn+JDnSkxy+peLCgQ==
X-Received: by 2002:a92:4b02:0:b0:35c:d630:8c9a with SMTP id m2-20020a924b02000000b0035cd6308c9amr13465866ilg.28.1701304256638;
        Wed, 29 Nov 2023 16:30:56 -0800 (PST)
Received: from debian ([131.107.1.242])
        by smtp.gmail.com with ESMTPSA id f3-20020aa782c3000000b0068fd026b496sm11299444pfn.46.2023.11.29.16.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 16:30:56 -0800 (PST)
Date: Wed, 29 Nov 2023 16:30:54 -0800
From: Pierre Mariani <pierre.mariani@gmail.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com
Subject: Re: [PATCH 2/4] smb: client: Protect ses->chans update with
 chan_lock spin lock
Message-ID: <ZWfXvixWhkZRO_SF@debian>
References: <b9f9f617abc69d0a7ddb3109bc257073c8b165de.1701060106.git.pierre.mariani@gmail.com>
 <234ee19f9706fa55af3bae3e339e39c42d5b0b0a.1701060106.git.pierre.mariani@gmail.com>
 <CANT5p=o6NBZn15pVk885tC7PhRoYJjw5-Mx0Li5EN6_MTw7-ow@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANT5p=o6NBZn15pVk885tC7PhRoYJjw5-Mx0Li5EN6_MTw7-ow@mail.gmail.com>

On Wed, Nov 29, 2023 at 02:30:37PM +0530, Shyam Prasad N wrote:
> On Mon, Nov 27, 2023 at 10:22 AM Pierre Mariani
> <pierre.mariani@gmail.com> wrote:
> >
> > Protect the update of ses->chans with chan_lock spin lock as per documentation
> > from cifsglob.h.
> > Fixes Coverity 1561738.
> >
> > Signed-off-by: Pierre Mariani <pierre.mariani@gmail.com>
> > ---
> >  fs/smb/client/connect.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > index 449d56802692..0512835f399c 100644
> > --- a/fs/smb/client/connect.c
> > +++ b/fs/smb/client/connect.c
> > @@ -2055,6 +2055,7 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
> >         spin_unlock(&cifs_tcp_ses_lock);
> >
> >         /* close any extra channels */
> > +       spin_lock(&ses->chan_lock);
> >         for (i = 1; i < ses->chan_count; i++) {
> >                 if (ses->chans[i].iface) {
> >                         kref_put(&ses->chans[i].iface->refcount, release_iface);
> > @@ -2063,11 +2064,14 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
> >                 cifs_put_tcp_session(ses->chans[i].server, 0);
> >                 ses->chans[i].server = NULL;
> >         }
> > +       spin_unlock(&ses->chan_lock);
> >
> >         /* we now account for primary channel in iface->refcount */
> >         if (ses->chans[0].iface) {
> >                 kref_put(&ses->chans[0].iface->refcount, release_iface);
> > +               spin_lock(&ses->chan_lock);
> >                 ses->chans[0].server = NULL;
> > +               spin_unlock(&ses->chan_lock);
> >         }
> >
> >         sesInfoFree(ses);
> > --
> > 2.39.2
> >
> >
> 
> Hi Pierre,
> 
> Thanks for proposing this change.
> 
> While it is true in general that chan_lock needs to be locked when
> dealing with session channel details, this particular instance above
> is during __cifs_put_smb_ses.
> And this code is reached when ses_count has already reached 0. i.e.
> this process is the last user of the session.
> So taking chan_lock can be avoided. We did have this under a lock
> before, but it resulted in deadlocks due to calls to
> cifs_put_tcp_session, which locks bigger locks.
> So the quick and dirty fix at that point was to not take chan_lock
> here, knowing that we'll be the last user.
> 
> Perhaps a better fix exists?
> Or we should probably document this as a comment for now.
> 
> This version of the patch will result in the deadlocks again.

Thank you for educating me on this, Shyam. I will re-read the code from that
point of view and see if I can think of any improvement.

> 
> -- 
> Regards,
> Shyam
