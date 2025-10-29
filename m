Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C293590CF
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 12:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761741596; cv=none; b=KKRknJ1Nnqc8mIRoumnSIAKjwcceOs8FB1hpkn9Nsl5AgeJ8eTEAqJpslSgbwj/2ddbLhWghESrbboaiyadcW8Bby7O40ncxs+hAAN4yWdVzIO9iKb3kzrS6LhAnUASSOWUCYbyRyOWnmVbA3zH22dx5ra+8VBKP0pMzOCx/DcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761741596; c=relaxed/simple;
	bh=49uoYhGHfXMZ7fHW+QKE2oV//6ZJ+ZzysmMJi1Z6ags=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C4ixNJVDO4sRMrJjQxCchXEYvZBfGOw4FdslePd7STlHIVwnJGSkz6S9Ij8dgkvC/ENk26Egb7HJbd0v66LDJqg0JGg6ZpFF3JSa/Ec8Pnzd1Eft+f00vHoHRCGcNm/gdFzrdB/VqoNTpPHeljwFuQY08s3rADRNSVEjc0Uxy2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kakEeUXf; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kakEeUXf"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b6d4e44c54aso1231261466b.2
        for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 05:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761741592; x=1762346392; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NQxjbIg9YwIhwxVpY0QdcqzIhsWq2MPobbBZ+ikGI+Q=;
        b=kakEeUXfiq2w2kDBXLhgAs9SiU/+2WFLw8AfgILmBNIAi57+qumy8uSj6ej2nL7LM8
         WJT9S7E/4i5MLWtclWTgaBiugcpS76QaqE3urH1RxzwKaXryHS7SQZBQwEWdh04qp9gF
         cAuTjMHUGqcC208LHRZ2jEdLDrEoBHXeJetqHSMzRp+s0xkjqfi6eO10KubI0UDav+0C
         MZzY3EgFVjYfB5W45ujh0/EouOJ0qrtXTl6oluKVOyiSBkjcCZMXAfq6nlPS+S0ptEUQ
         rokXxDT7zUO+IjLKL4OofCmMaQAWjxOP52EFgBB/jeTw1OAJpgs5fi8yeMGs8Ktkem5c
         H7Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761741592; x=1762346392;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NQxjbIg9YwIhwxVpY0QdcqzIhsWq2MPobbBZ+ikGI+Q=;
        b=vKnyH970Fz3Cp8xm3KKSfrUrVSvY9UXbLauMgVDxgvIgEY6fp2FeoWG+3wi2uoNlXg
         8X4PNMy6+4JFylSs72VhmYW0rZInTm8hokdoZs7g/42yimSKIKEddQbgutIHwb+G8qz1
         HH59B+mRov13jnd700Zfw8xOkS6QdReWKF3Ay3D4p64U5Ccg35/TqI07D5Cqm40+4XmB
         Lw84M8+Tgeet9L96MqJl8FxLp87jwTf/wYjYKXVR/uxbNBK+Oocan4p3TY9bfoxcBC7L
         EDb8Z+YksaDYtJ+3pYW2EcMQE96anOLj309T4MCXYgYZJVXi/DadlcovuQUuOX6yZ5qB
         NfmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSTQlfxRv4RTlqjxtTJxbv6IRSWthdmlUM77I4wx+UyHbC4Nj3Ot4Hf9xQ9rzOMXnl38dv1EDrXUvV@vger.kernel.org
X-Gm-Message-State: AOJu0YwuyLqsWOq9+XkcmL/+MQeWfVg4PjxAwz5l3Jcf0PhfGPwgOCQB
	5QQ5W5inuuGFXe98qFLld2iYpHQN9UHiCBaug9iHfmh1PVAg3OToGc80
X-Gm-Gg: ASbGncvdKnPc0Wujxo1SXniiAgwUdHDxPTjJJAeZj7TY4U78PL445XDL1NHkKW58P7g
	fARP90GuCAVrlDeBCg0OwI0AIz94K7q87LR4G5jxV+/6tzfgUrMPr5njhwTewyN9V96rn0dS0Ed
	kQTSpT+4mdkl/Wt72I85jMkrloD7qdyzvpqL1ev8GkiD0BxLzioBtVLBUGmicE8NJ7z5Jc1Urb/
	s6k7HOPH1oXtrLfIlcPPgHx0cXXTnu8g56eWCigDF8XicgEUbuiiW/OHN4iOdexz3dQi8SLnGxT
	+W2qEH9Ah9MDKaWWBXXSJxY9XgEE5Hf4hqzuaoot5gCgVv7tZXXjodbTXsmptrPsddEBz0ACq0d
	NjP23jURltgQjXrpBFPaJV7JTjbF0C+KHyfF8wp5R+n/PSzLbUE+EPoY0ps9RUDYzeXAO9SholY
	TsdxWDc35/MIDvQA9t8SM/3UgJW3k+1uiyKvYkjFkNVx21K1RmP/bWZzZyqLYFK1Mtz1wX+Pm6A
	AAhEw==
X-Google-Smtp-Source: AGHT+IFsngk/ZlQIhI18Mif9/b0xuGaoAFM7gcHRok1LLBFKKKebUqlC+tev6r6ZeRr03qQ50LjyDQ==
X-Received: by 2002:a17:907:3f21:b0:b3f:9b9c:d49e with SMTP id a640c23a62f3a-b703d555a9bmr276600566b.57.1761741591895;
        Wed, 29 Oct 2025 05:39:51 -0700 (PDT)
Received: from localhost (2001-1c00-570d-ee00-762a-9cfa-f6a7-22df.cable.dynamic.v6.ziggo.nl. [2001:1c00:570d:ee00:762a:9cfa:f6a7:22df])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d8538478fsm1427867566b.33.2025.10.29.05.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 05:39:51 -0700 (PDT)
Date: Wed, 29 Oct 2025 13:39:50 +0100
From: Amir Goldstein <amir73il@gmail.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Jan Kara <jack@suse.cz>, sfrench@samba.org, pc@manguebit.org,
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
	bharathsm@microsoft.com, linux-cifs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Stef Bon <stefbon@gmail.com>,
	Ioannis Angelakopoulos <iangelak@redhat.com>
Subject: Re: [RFC PATCH 2/2] smb: client: add directory change tracking via
 SMB2 Change Notify
Message-ID: <aQILFtsVnpVBj-k-@amir-ThinkPad-T480>
References: <20250916133437.713064-1-ekffu200098@gmail.com>
 <20250916133437.713064-3-ekffu200098@gmail.com>
 <CABFDxMFtZKSr5KbqcGQzJWYwT5URUYeuEHJ1a_jDUQPO-OKVGg@mail.gmail.com>
 <CAOQ4uxgEL=gOpSaSAV_+U=a3W5U5_Uq2Sk4agQhUpL4jHMMQ9w@mail.gmail.com>
 <CABFDxMG8uLaedhFuWHLAqW75a=TFfVEHkm08uwy76B7w9xbr=w@mail.gmail.com>
 <CAOQ4uxj9BAz6ibV3i57wgZ5ZNY9mvow=6-iJJ7b4pZn4mpgF7A@mail.gmail.com>
 <CABFDxMFRhKNENWyqh3Yraq_vDh0P=KxuXA9RcuVPX4FUnhKqGw@mail.gmail.com>
 <CAOQ4uxjxG7KCwsHYv3Oi+t1pwjLS8jUoiAroXtzTatu3+11CWg@mail.gmail.com>
 <CABFDxMGyH9jek19qEzp-3cQiS=9CTXzvtVDZztouLeO6nYEP3w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABFDxMGyH9jek19qEzp-3cQiS=9CTXzvtVDZztouLeO6nYEP3w@mail.gmail.com>

On Wed, Oct 29, 2025 at 01:13:31AM +0900, Sang-Heon Jeon wrote:
> On Fri, Oct 24, 2025 at 12:30 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > ...
> > > > > Hello, Amir
> > > > >
> > > > > > First feedback (value):
> > > > > > -----------------------------
> > > > > > This looks very useful. this feature has been requested and
> > > > > > attempted several times in the past (see links below), so if you are
> > > > > > willing to incorporate feedback, I hope you will reach further than those
> > > > > > past attempts and I will certainly do my best to help you with that.
> > > > >
> > > > > Thanks for your kind comment. I'm really glad to hear that.
> > > > >
> > > > > > Second feedback (reviewers):
> > > > > > ----------------------------------------
> > > > > > I was very surprised that your patch doesn't touch any vfs code
> > > > > > (more on that on design feedback), but this is not an SMB-contained
> > > > > > change at all.
> > > > >
> > > > > I agree with your last comment. I think it might not be easy;
> > > > > honestly, I may know less than
> > > > > Ioannis or Vivek; but I'm fully committed to giving it a try, no
> > > > > matter the challenge.
> > > > >
> > > > > > Your patch touches the guts of the fsnotify subsystem (in a wrong way).
> > > > > > For the next posting please consult the MAINTAINERS entry
> > > > > > of the fsnotify subsystem for reviewers and list to CC (now added).
> > > > >
> > > > > I see. I'll keep it in my mind.
> > > > >
> > > > > > Third feedback (design):
> > > > > > --------------------------------
> > > > > > The design choice of polling i_fsnotify_mask on readdir()
> > > > > > is quite odd and it is not clear to me why it makes sense.
> > > > > > Previous discussions suggested to have a filesystem method
> > > > > > to update when applications setup a watch on a directory [1].
> > > > > > Another prior feedback was that the API should allow a clear
> > > > > > distinction between the REMOTE notifications and the LOCAL
> > > > > > notifications [2][3].
> > > > >
> > > > > Current design choice is a workaround for setting an appropriate add
> > > > > watch point (as well as remove). I don't want to stick to the RFC
> > > > > design. Also, The point that I considered important is similar to
> > > > > Ioannis' one: compatible with existing applications.
> > > > >
> > > > > > IMO it would be better to finalize the design before working on the
> > > > > > code, but that's up to you.
> > > > >
> > > > > I agree, although it's quite hard to create a perfect blueprint, but
> > > > > it might be better to draw to some extent.
> > > > >
> > > > > Based on my current understanding, I think we need to do the following things.
> > > > > - design more compatible and general fsnotify API for all network fs;
> > > > > should process LOCAL and REMOTE both smoothly.
> > > > > - expand inotify (if needed, fanotify both) flow with new fsnotify API
> > > > > - replace SMB2 change_notify start/end point to new API
> > > > >
> > > >
> > > > Yap, that's about it.
> > > > All the rest is the details...
> > > >
> > > > > Let me know if I missed or misunderstood something. And also please
> > > > > give me some time to read attached threads more deeply and clean up my
> > > > > thoughts and questions.
> > > > >
> > > >
> > > > Take your time.
> > > > It's good to understand the concerns of previous attempts to
> > > > avoid hitting the same roadblocks.
> > >
> > > Good to see you again!
> > >
> > > I read and try to understand previous discussions that you attached. I
> > > would like to ask for your opinion about my current step.
> > > I considered different places for new fsnotify API. I came to the same
> > > conclusion that you already suggested to Inoannis [1]
> > > After adding new API to `struct super_operations`, I tried to find the
> > > right place for API calls that would not break existing systems and
> > > have compatibility with inotify and fanotify.
> > >
> > > From my current perspective, I think the outside of fsnotify (like
> > > inotify_user.c/fanotify_user.c) is a better place to call new API.
> > > Also, it might lead some duplicate code with inotify and fanotify, but
> > > it seems difficult to create one unified logic that covers both
> > > inotify and fanotify.
> >
> >
> > Personally, I don't mind duplicating this call in the inotify and
> > fanotify backends.
> > Not sure if this feature is relevant to other backends like nfsd and audit.
> >
> > I do care about making this feature opt-in, which goes a bit against your
> > requirement that existing applications will get the REMOTE notifications
> > without opting in for them and without the notifications being clearly marked
> > as REMOTE notifications.
> >
> > If you do not make this feature opt-in (e.g. by fanotify flag FAN_MARK_REMOTE)
> > then it's a change of behavior that could be desired to some and surprising to
> > others.
> 
> You're right, Upon further reflection, my previous approach may create
> unexpected effects to the user program. But to achieve my requirement,
> inotify should be supported (also safely). I will revisit inotify with
> opt-in method after finishing the discussion about fanotify.
> 
> > Also when performing an operation on the local smb client (e.g. unlink)
> > you would get two notifications, one the LOCAL and one the REMOTE,
> > not being able to distinguish between them or request just one of them
> > is going to be confusing.
> >
> > > With this approach, we could start inotify first
> > > and then fanotify second that Inoannis and Vivek already attempted.
> > > Even if unified logic is possible, I don't think it is not difficult
> > > to merge and move them into inside of fsnotify (like mark.c)
> > >
> >
> > For all the reasons above I would prefer to support fanotify first
> > (with opt-in flag) and not support inotify at all, but if you want to
> > support inotify, better have some method to opt-in at least.
> > Could be a global inotify kob for all I care, as long as the default
> > does not take anyone by surprise.
> 
> Thanks for the detailed description. I understand the point of
> distinguishing remote and local notification better. And the way you
> prefer (fanotify first) is also reasonable to me because implementing
> fanotify would also help support inotify more safely.
> 
> > > Also, I have concerns when to call the new API. I think after updating
> > > the mark is a good moment to call API if we decide to ignore errors
> > > from new API; now, to me, it is affordable in terms of minimizing side
> > > effect and lower risk with user spaces. However, eventually, I believe
> > > the user should be able to decide whether to ignore the error or not
> > > of new API, maybe by config or flag else. In that case, we need to
> > > rollback update of fsnotify when new API fails. but it is not
> > > supported yet. Could you share your thoughts on this, too?
> > >
> >
> > If you update remote mask with explicit FAN_MARK_REMOTE
> > and update local mask without FAN_MARK_REMOTE, then
> > there is no problem is there?
> >
> > Either FAN_MARK_REMOTE succeeded or not.
> > If it did, remote fs could be expected to generate remote events.
> 
> I understand you mean splitting mask into a local and remote
> notification instead of sharing, is it right?

No, that's no what I meant.

> TBH, I never thought of that solution but it's quite clear and looks good to me.
> If I misunderstand, could you please explain a bit more?
> 

It is indeed clear, but inode space is quite expensive, so we cannot
add i_fsnotify_remote_mask field for all inodes and also its not
necessary.

TBH, I do have a final picture of the opt-in API and there are several
shapes that it could take.

I think that we anyway need an "event mask flag" FAN_REMOTE,
similar to FAN_ONDIR.

A remote notification is generated by the filesystem and this source
of notification always sets the FS_REMOTE in the event mask, which is
visible to users reading the events.

This makes it natural to also opt-in for remote events via the mask,
some as is done with FAN_ONDIR.

However, I would like to avoid the complexities involved with flipping
this FS_REMOTE bit in event mask, that's why I was thinking about
FAN_MARK_REMOTE that sets a flag in the mark, like FAN_MARK_EVICTABLE
and forces all mark updates to use the same flag.

But for your first RFC, I suggest that you make it simple and use
a group flag to request only remote notifications at fanotify_init
time.

This way you can take the existing cifs implementation of remote
notifications using an ioctl and "bind" it to use the fanotify API
with as little interferance with local notifications as possible.

> > > If my inspection is wrong or you might have better idea, please let me
> > > know about it. TBH, understanding new things is hard, but it's also a
> > > happy moment to me.
> > >
> >
> > I am relying on what I think you mean, but I may misunderstand you
> > because you did not sketch any code samples, so I don't believe
> > I fully understand all your concerns and ideas.
> >
> > Even an untested patch could help me understand if we are on the same page.
> 
> Thanks for your advice. I think we're getting closer to the same page.

Not quite there yet :)

> I also attached patch of my current sketch (not tested and cleaned),
> feel free to give your opinions.

This is not what I was looking for.

What I am looking for is a POC patch of binding cifs notifications
to fsnotify/fanotify:

- fanotify_mask() calls filesystem method to update server event mask
- filesystem calls fnsotify() hook with FS_REMOTE flag
- groups or marks that did not opt-in for remote notifications
  would drop this event

First milestone: be able to write program that listens to remote
notifications only.

Same program can use two groups remote and local with mask per type
to request a mixture of local and remote events.

Honestly, I don't think we need more than that?

Thanks,
Amir.


