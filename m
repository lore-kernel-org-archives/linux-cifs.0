Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iFZ2EI75"
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044B8119
	for <linux-cifs@vger.kernel.org>; Sat,  2 Dec 2023 22:36:02 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-7b37dd4bb35so127678239f.3
        for <linux-cifs@vger.kernel.org>; Sat, 02 Dec 2023 22:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701585362; x=1702190162; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZOYjk3fBCrVbXQrD12LPYY82QoNmvGMphdENcKryFjM=;
        b=iFZ2EI75FauYL5zkWbfbkPhcn9sxsQrGcvGnGCDkYOmid9yxXKEJWBH4qAiPMg8uBV
         HIXzO4BSJ477rGEhNM4FRvbDGQzxnMnWT8xlO29wvR1uoCTDJtONVoT0VCwWinN6GCJt
         KLjXg8qzsBM1c3tLR3y8mzoDsfVKQ0lsP7/O/h3whjC/AJX8LVBSP4dM4tUiOQK2yRLC
         +7YXmzQ/+bl2sNfrzVNqYqUg04cFPwPqGWPW/3FabNC3hooX43P1RjZUEZTvXj+zMLVD
         BHK+2+Maht6zrzH3DClQKKU69YENHnPWZnO3xdDbz0TA6GvBVSkKBsnqvwwfZy1xOQWQ
         3yLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701585362; x=1702190162;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZOYjk3fBCrVbXQrD12LPYY82QoNmvGMphdENcKryFjM=;
        b=B6fM8C35jq5x4xzJRNdMdGjE/CfUqNat25Maz1mePj2C4pqLR/MfHvaD9LcZ346yWd
         tEFZD+7MIUH+IFXdJfkTfCgt+MinmPDw8TMX85Y/Aq18SdmUhGV9dj+e7nZDmOOvsuHZ
         A+t9Sqs17CqagC+7p0p3wM2v3xNt5f7OBiv7cqIAk8sPokiRwX5ipcE9R9NAZfvB6KBL
         M+pulpFQX64RQzX+XLRi8Iyfp34sWW2Ldzd+dYPvI1xsGxKcDzZWMgbQNbWZZJMx2JyP
         jSGLWf+iEdaWsrs8iJZSQ84bgC2kqqN+6ANn/3mJtShG1HmYlD7SrXG49743s8qCox+P
         W4TA==
X-Gm-Message-State: AOJu0YzteQYYqA/pgtSFe6NuWTIlGa9EkrqemdgiXoGQZcBcvue5k2Dl
	0SUhUxH1Hd5nCQ0UDCGGKAA=
X-Google-Smtp-Source: AGHT+IEI3FH9+iyQppuiOkrmKy3NKsMeQCb+rCjb/kNljXr1CvYNHHQEUBk9EpQth0Mlwa3bBVBvAA==
X-Received: by 2002:a6b:ec19:0:b0:7b0:ae77:36ec with SMTP id c25-20020a6bec19000000b007b0ae7736ecmr2624017ioh.9.1701585362159;
        Sat, 02 Dec 2023 22:36:02 -0800 (PST)
Received: from debian (c-73-109-30-110.hsd1.wa.comcast.net. [73.109.30.110])
        by smtp.gmail.com with ESMTPSA id l17-20020a170902eb1100b001d060d6cde0sm3439675plb.162.2023.12.02.22.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Dec 2023 22:36:01 -0800 (PST)
Date: Sat, 2 Dec 2023 22:36:00 -0800
From: Pierre Mariani <pierre.mariani@gmail.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com
Subject: Re: [PATCH 2/4] smb: client: Protect ses->chans update with
 chan_lock spin lock
Message-ID: <ZWwh0BEvUcbFdal6@debian>
References: <b9f9f617abc69d0a7ddb3109bc257073c8b165de.1701060106.git.pierre.mariani@gmail.com>
 <234ee19f9706fa55af3bae3e339e39c42d5b0b0a.1701060106.git.pierre.mariani@gmail.com>
 <CANT5p=o6NBZn15pVk885tC7PhRoYJjw5-Mx0Li5EN6_MTw7-ow@mail.gmail.com>
 <ZWfXvixWhkZRO_SF@debian>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZWfXvixWhkZRO_SF@debian>

On Wed, Nov 29, 2023 at 04:30:54PM -0800, Pierre Mariani wrote:
> On Wed, Nov 29, 2023 at 02:30:37PM +0530, Shyam Prasad N wrote:
> > On Mon, Nov 27, 2023 at 10:22 AM Pierre Mariani
> > <pierre.mariani@gmail.com> wrote:
> > >
> > > Protect the update of ses->chans with chan_lock spin lock as per documentation
> > > from cifsglob.h.
> > > Fixes Coverity 1561738.
> > >
> > > Signed-off-by: Pierre Mariani <pierre.mariani@gmail.com>
> > > ---
> > >  fs/smb/client/connect.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > > index 449d56802692..0512835f399c 100644
> > > --- a/fs/smb/client/connect.c
> > > +++ b/fs/smb/client/connect.c
> > > @@ -2055,6 +2055,7 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
> > >         spin_unlock(&cifs_tcp_ses_lock);
> > >
> > >         /* close any extra channels */
> > > +       spin_lock(&ses->chan_lock);
> > >         for (i = 1; i < ses->chan_count; i++) {
> > >                 if (ses->chans[i].iface) {
> > >                         kref_put(&ses->chans[i].iface->refcount, release_iface);
> > > @@ -2063,11 +2064,14 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
> > >                 cifs_put_tcp_session(ses->chans[i].server, 0);
> > >                 ses->chans[i].server = NULL;
> > >         }
> > > +       spin_unlock(&ses->chan_lock);
> > >
> > >         /* we now account for primary channel in iface->refcount */
> > >         if (ses->chans[0].iface) {
> > >                 kref_put(&ses->chans[0].iface->refcount, release_iface);
> > > +               spin_lock(&ses->chan_lock);
> > >                 ses->chans[0].server = NULL;
> > > +               spin_unlock(&ses->chan_lock);
> > >         }
> > >
> > >         sesInfoFree(ses);
> > > --
> > > 2.39.2
> > >
> > >
> > 
> > Hi Pierre,
> > 
> > Thanks for proposing this change.
> > 
> > While it is true in general that chan_lock needs to be locked when
> > dealing with session channel details, this particular instance above
> > is during __cifs_put_smb_ses.
> > And this code is reached when ses_count has already reached 0. i.e.
> > this process is the last user of the session.
> > So taking chan_lock can be avoided. We did have this under a lock
> > before, but it resulted in deadlocks due to calls to
> > cifs_put_tcp_session, which locks bigger locks.
> > So the quick and dirty fix at that point was to not take chan_lock
> > here, knowing that we'll be the last user.
> > 
> > Perhaps a better fix exists?
> > Or we should probably document this as a comment for now.
> > 
> > This version of the patch will result in the deadlocks again.
> 
> Thank you for educating me on this, Shyam. I will re-read the code from that
> point of view and see if I can think of any improvement.
> 

Looking at the code in more details, I can see how the order of relevant locks
is cifs_tcp_ses_lock > srv_lock > chan_lock.
cifs_tcp_ses_lock and srv_lock are locked by cifs_put_tcp_session.
__cifs_put_smb_ses calls cifs_put_tcp_session. Hence we cannot lock chan_lock
and then call cifs_put_tcp_session or the lock order will not be respected.

To work around this issue, the following change could be made to read the value
of ses->chan_lock while holding chan_lock, but release it before starting the
loop where cifs_put_tcp_session is called.

-       for (i = 1; i < ses->chan_count; i++) {
+       spin_lock(&ses->chan_lock);
+       int ses_chan_count = ses->chan_count;
+
+       spin_unlock(&ses->chan_lock);
+
+       for (i = 1; i < ses_chan_count; i++) {

Please, let me know if this is acceptable.

> > 
> > -- 
> > Regards,
> > Shyam
