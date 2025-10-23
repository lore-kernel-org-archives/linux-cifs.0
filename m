Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4572632D7F7
	for <linux-cifs@vger.kernel.org>; Thu, 23 Oct 2025 15:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761233425; cv=none; b=PaiQaW977zYDpaC6W7GSz6X3ZTG25F9AnIm6pr0A/Xif51E0CwtE1GF/rvH4koO6hxWyXKAoSAMVF4yXMvWXyibIEQZDFLiM2ZK2SmJXtEXCpDJ8jr+eg8HoS63o7ML7BnO7YEU8P6ELKAotkG6ygikm1WMg8JBfMryegRmNDkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761233425; c=relaxed/simple;
	bh=R1DLxxQVstkHMMSgFPTDNmcwPzVc+mL9pMgA1atSRTY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R2dZwxcpYqqkawIl6F5C5dX9ECltKfvI+BRUURMu34BhMAZg0TfszD4jmcjd6CiaIkaAiJx/WtswbAEPzOZtGI9ZTQBHUkFu0+3c12iKFDwOLnufUj5/v9OKycHiygM6voUnbF3gqIfkTHD2MRLtGREwsZ0b7akGyzRUojZqZ+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TJT98v+n; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TJT98v+n"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-63c2d72581fso1607125a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 23 Oct 2025 08:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761233422; x=1761838222; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R1DLxxQVstkHMMSgFPTDNmcwPzVc+mL9pMgA1atSRTY=;
        b=TJT98v+ndVZj3FI9oaHsFuWmqXVXDepdxaT1AHo8MuiDCKaENVV82hV9bYYsiypPDD
         fO6evQSHY2csvk9M897Orh/IVfeLflEgKvN1Jr67X9RFVPexNAMqP5O32R+7wutE6eys
         KOpHgw1GUUHdzpZ8uogSMWk/HlYXh+AOTGS8FqR2+rZOhAiaMeTNItccwzhZmDRDfRkf
         mjHEWXQZHpjASvE+/nM2c+3ppY+Xsbj0xoo5802FMxZdIXhHtIEt1GgbwdnS5OaWynQj
         etmO67Fj6Ki9YbTSrUbr4uZWbF1ZwBqriehtbyZ156ftduVL2Yiw/8cW21UZrVrT8g5q
         lp7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761233422; x=1761838222;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R1DLxxQVstkHMMSgFPTDNmcwPzVc+mL9pMgA1atSRTY=;
        b=Tq+3AFxIEeUjIjLy+HtfbyWwDb7Z3Fzv36/RYkkKQvJoA2YZiD6CBSBPDJ6PL1SWcG
         eLTFBlhTNSvhXPaZTFkxvtyKhvYse+OKuoBUHdULWlGvNXIdOwSaFBuQvjkmqFzfhw35
         PE4kuJTKWEVpLGNohxCsKtTMTNkS+T0SiUYRumxMDuuiNelf5xmb2yadipVdCYiM3f5H
         3nxDnSLQBeL5kAIPcshGU43yxpUihHspxunNHQsZ1hJ4xPqsA9hg8NQfjEJTLClkh1sg
         z2U/bnFl5brVGpgN9zF3bfiGfEMV8p5UgF5lNsg/gBZSToIt7wgum1PXYTShjXsetTwU
         OdBw==
X-Forwarded-Encrypted: i=1; AJvYcCUHes++HS9Dou1uz+a/nnZYSzdE6WpqUEGhax1GxyB12GJSQTRgrsg7Zf6F0mt7aO8Q5Jl/uirYZp2e@vger.kernel.org
X-Gm-Message-State: AOJu0YzI8kEpoWtQSEoTtFqrPRSBuXU0nnGHICkn/Eou0xPyiKpHToAa
	/pR5+OuD+SmyU1k4XcoVoE7bzWA8Vv851MtvlmOtgksyjlRd/kXWL+u5BCH9YeHwejEsg907GZq
	T4tPD3XwaAlXVj12UWgO0Wz9THSL1XnQ=
X-Gm-Gg: ASbGncufv1vuPHPWB3+Rv6DhlGs1b7uanNGy/DtPuU3GwCvJ8vq9HaVyd5cU9HB+P94
	REL7F+RWlb9UL3VcMOuS5TLKmM8Gc+VLEtAzncBsThnHlWWyNjyEGYaApXrqE+7aTmzTee9wyHB
	Tp4hxevsPrHaMCNfN9nkxWbcl8zycnKf5jHzpVyvKn7Ao3zKhNu3hZE24tsvR577TmVohEtSXH0
	h1aLQUjb+EGCnJsgM42/Y0bO8Ey2+pTc9U+tg/TMRQqtCSOPszakG8mgba8JuizKb3XwpiLgPNz
	PSbfmW2p/p8eZk9sytY=
X-Google-Smtp-Source: AGHT+IGeg4VShtIIbMZDn43Tom+FCrQ/WOrg0eWdTj7Vv7kLxp9SIc+Im9ri1X7/944ylkzI7ZpCmF9a14W06dA2vLw=
X-Received: by 2002:a05:6402:5cb:b0:639:fca4:c471 with SMTP id
 4fb4d7f45d1cf-63c1f6e04eemr24527060a12.28.1761233421236; Thu, 23 Oct 2025
 08:30:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250916133437.713064-1-ekffu200098@gmail.com>
 <20250916133437.713064-3-ekffu200098@gmail.com> <CABFDxMFtZKSr5KbqcGQzJWYwT5URUYeuEHJ1a_jDUQPO-OKVGg@mail.gmail.com>
 <CAOQ4uxgEL=gOpSaSAV_+U=a3W5U5_Uq2Sk4agQhUpL4jHMMQ9w@mail.gmail.com>
 <CABFDxMG8uLaedhFuWHLAqW75a=TFfVEHkm08uwy76B7w9xbr=w@mail.gmail.com>
 <CAOQ4uxj9BAz6ibV3i57wgZ5ZNY9mvow=6-iJJ7b4pZn4mpgF7A@mail.gmail.com> <CABFDxMFRhKNENWyqh3Yraq_vDh0P=KxuXA9RcuVPX4FUnhKqGw@mail.gmail.com>
In-Reply-To: <CABFDxMFRhKNENWyqh3Yraq_vDh0P=KxuXA9RcuVPX4FUnhKqGw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 23 Oct 2025 17:30:10 +0200
X-Gm-Features: AS18NWD7qJ545TV4uDRrLbxUlzGi9tt1Qfmxci_lB1sZ8ABllrsSvhU5Z_9KIB8
Message-ID: <CAOQ4uxjxG7KCwsHYv3Oi+t1pwjLS8jUoiAroXtzTatu3+11CWg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] smb: client: add directory change tracking via
 SMB2 Change Notify
To: Sang-Heon Jeon <ekffu200098@gmail.com>, Jan Kara <jack@suse.cz>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Stef Bon <stefbon@gmail.com>, Ioannis Angelakopoulos <iangelak@redhat.com>
Content-Type: text/plain; charset="UTF-8"

...
> > > Hello, Amir
> > >
> > > > First feedback (value):
> > > > -----------------------------
> > > > This looks very useful. this feature has been requested and
> > > > attempted several times in the past (see links below), so if you are
> > > > willing to incorporate feedback, I hope you will reach further than those
> > > > past attempts and I will certainly do my best to help you with that.
> > >
> > > Thanks for your kind comment. I'm really glad to hear that.
> > >
> > > > Second feedback (reviewers):
> > > > ----------------------------------------
> > > > I was very surprised that your patch doesn't touch any vfs code
> > > > (more on that on design feedback), but this is not an SMB-contained
> > > > change at all.
> > >
> > > I agree with your last comment. I think it might not be easy;
> > > honestly, I may know less than
> > > Ioannis or Vivek; but I'm fully committed to giving it a try, no
> > > matter the challenge.
> > >
> > > > Your patch touches the guts of the fsnotify subsystem (in a wrong way).
> > > > For the next posting please consult the MAINTAINERS entry
> > > > of the fsnotify subsystem for reviewers and list to CC (now added).
> > >
> > > I see. I'll keep it in my mind.
> > >
> > > > Third feedback (design):
> > > > --------------------------------
> > > > The design choice of polling i_fsnotify_mask on readdir()
> > > > is quite odd and it is not clear to me why it makes sense.
> > > > Previous discussions suggested to have a filesystem method
> > > > to update when applications setup a watch on a directory [1].
> > > > Another prior feedback was that the API should allow a clear
> > > > distinction between the REMOTE notifications and the LOCAL
> > > > notifications [2][3].
> > >
> > > Current design choice is a workaround for setting an appropriate add
> > > watch point (as well as remove). I don't want to stick to the RFC
> > > design. Also, The point that I considered important is similar to
> > > Ioannis' one: compatible with existing applications.
> > >
> > > > IMO it would be better to finalize the design before working on the
> > > > code, but that's up to you.
> > >
> > > I agree, although it's quite hard to create a perfect blueprint, but
> > > it might be better to draw to some extent.
> > >
> > > Based on my current understanding, I think we need to do the following things.
> > > - design more compatible and general fsnotify API for all network fs;
> > > should process LOCAL and REMOTE both smoothly.
> > > - expand inotify (if needed, fanotify both) flow with new fsnotify API
> > > - replace SMB2 change_notify start/end point to new API
> > >
> >
> > Yap, that's about it.
> > All the rest is the details...
> >
> > > Let me know if I missed or misunderstood something. And also please
> > > give me some time to read attached threads more deeply and clean up my
> > > thoughts and questions.
> > >
> >
> > Take your time.
> > It's good to understand the concerns of previous attempts to
> > avoid hitting the same roadblocks.
>
> Good to see you again!
>
> I read and try to understand previous discussions that you attached. I
> would like to ask for your opinion about my current step.
> I considered different places for new fsnotify API. I came to the same
> conclusion that you already suggested to Inoannis [1]
> After adding new API to `struct super_operations`, I tried to find the
> right place for API calls that would not break existing systems and
> have compatibility with inotify and fanotify.
>
> From my current perspective, I think the outside of fsnotify (like
> inotify_user.c/fanotify_user.c) is a better place to call new API.
> Also, it might lead some duplicate code with inotify and fanotify, but
> it seems difficult to create one unified logic that covers both
> inotify and fanotify.


Personally, I don't mind duplicating this call in the inotify and
fanotify backends.
Not sure if this feature is relevant to other backends like nfsd and audit.

I do care about making this feature opt-in, which goes a bit against your
requirement that existing applications will get the REMOTE notifications
without opting in for them and without the notifications being clearly marked
as REMOTE notifications.

If you do not make this feature opt-in (e.g. by fanotify flag FAN_MARK_REMOTE)
then it's a change of behavior that could be desired to some and surprising to
others.

Also when performing an operation on the local smb client (e.g. unlink)
you would get two notifications, one the LOCAL and one the REMOTE,
not being able to distinguish between them or request just one of them
is going to be confusing.

> With this approach, we could start inotify first
> and then fanotify second that Inoannis and Vivek already attempted.
> Even if unified logic is possible, I don't think it is not difficult
> to merge and move them into inside of fsnotify (like mark.c)
>

For all the reasons above I would prefer to support fanotify first
(with opt-in flag) and not support inotify at all, but if you want to
support inotify, better have some method to opt-in at least.
Could be a global inotify kob for all I care, as long as the default
does not take anyone by surprise.

> Also, I have concerns when to call the new API. I think after updating
> the mark is a good moment to call API if we decide to ignore errors
> from new API; now, to me, it is affordable in terms of minimizing side
> effect and lower risk with user spaces. However, eventually, I believe
> the user should be able to decide whether to ignore the error or not
> of new API, maybe by config or flag else. In that case, we need to
> rollback update of fsnotify when new API fails. but it is not
> supported yet. Could you share your thoughts on this, too?
>

If you update remote mask with explicit FAN_MARK_REMOTE
and update local mask without FAN_MARK_REMOTE, then
there is no problem is there?

Either FAN_MARK_REMOTE succeeded or not.
If it did, remote fs could be expected to generate remote events.

> If my inspection is wrong or you might have better idea, please let me
> know about it. TBH, understanding new things is hard, but it's also a
> happy moment to me.
>

I am relying on what I think you mean, but I may misunderstand you
because you did not sketch any code samples, so I don't believe
I fully understand all your concerns and ideas.

Even an untested patch could help me understand if we are on the same page.

Thanks,
Amir.
