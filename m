Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32612351C3F
	for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 10:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776855159; cv=none; b=Btua7hGa/LE/N1pKX4s9knNahhseDA05Lcee0UimIsaJyezK0Zu6UyDzHf8WNyIYfq8OG6QMmhIRJG1S72YXHUdTB1zThJCRpogSrUxBxvyG3UHrfKOY7hOvrWNYMfDnGOmoYw1r/6l/pRZ6FySZIjfNd4f9s+C46/DtB4ZXG88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776855159; c=relaxed/simple;
	bh=n7ua3IBTaT1I2IjXE3Fgx7EVHWOjfMqpf703jfD3SMg=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=RrXV0Iq4W3uq19dTxdeudyaG9Rq0ELjyP44C6wMMp3mz3cU3nbVYNYFYvlqdBapJaETBYO39kbcgZIevAmK3V8+5YIOP9nKGsYitz3ogctxX5bX6F8OOoWxfToLE+IdaK46mPg9seWabt5nxwOaN2MJh/VNGmP9sgEddzv4avCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=MB9QIKoB; arc=none smtp.client-ip=195.121.94.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="MB9QIKoB"
X-KPN-MessageId: 5b8e6a02-3e39-11f1-bea8-005056992ed3
Received: from mta.kpnmail.nl (unknown [10.31.161.190])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 5b8e6a02-3e39-11f1-bea8-005056992ed3;
	Wed, 22 Apr 2026 12:52:29 +0200 (CEST)
Received: from mtaoutbound.kpnmail.nl (unknown [10.128.135.190])
	by mta.kpnmail.nl (Halon) with ESMTP
	id 5b9d35db-3e39-11f1-99cc-0050569977a2;
	Wed, 22 Apr 2026 12:52:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:subject:message-id:to:from:date;
	bh=lzobZnGX3W1YHn5mkFfzRdme5gItKXvBwoKmmwvYuYE=;
	b=MB9QIKoBhYGJTaPRIxuMVE0UQUOVn5hpU6PZBDVnEv2N5ka7Y1xx6qPJaJAnxNpPe+PGePupkcXR3
	 keASuo99lRePl5/IrRo4fmKHnPT47pAVUYyKfeMGw0NYO34ZRCPMrrr4NGF2LxTHHdRAUw5/kWHXyK
	 la3JVKrtaQH1i44wS8WxRp1eDQ365tGsE5tINDXh6K3+A6arr5J91d4FGhNVtFZXMseNA2s4xZZJwL
	 U54RFI928yCmQNyzxXGVhLb9jlBuYV82pxHAWY7g4u9zTXLYw1EiwMOaSVtuUpYB1yy9RJDn0pN6Im
	 xpGu2ji8MLf619bNY835SNHnEdWT/iA==
X-KPN-MID: 33|xYmwcf1RlbXBSVW5pKHQRa4Le0Yr1IznKtlN52MTrEXCcQF0ejXqNFYiUc0I3DJ
 OYd+48D9GfLHX4T7LIg8gnxMMfvhtP0ZS/iNIE46CnFw=
X-CMASSUN: 33|Q91q0BWVgfkvoiGVF0kbRuMY3WwmrpvGX1u+s0vBkvPjeNI6td+AD8y2uyZF77I
 tVP8iuO9otNNc40cuf0LjdA==
X-KPN-VerifiedSender: Yes
Received: from cpxoxapps-mh08 (cpxoxapps-mh08.personalcloud.so.kpn.org [10.128.135.214])
	by mtaoutbound.kpnmail.nl (Halon) with ESMTPSA
	id 5b8a4992-3e39-11f1-b8d7-005056995d6c;
	Wed, 22 Apr 2026 12:52:29 +0200 (CEST)
Date: Wed, 22 Apr 2026 12:52:29 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>, NeilBrown <neil@brown.name>,
	Amir Goldstein <amir73il@gmail.com>,
	Jeff Layton <jlayton@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>,
	"open list:FILESYSTEMS (VFS and infrastructure)"
 <linux-fsdevel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
	"open list:KERNEL SMB3 SERVER (KSMBD)" <linux-cifs@vger.kernel.org>
Message-ID: <2033530362.1019505.1776855149486@kpc.webmail.kpnmail.nl>
In-Reply-To: <20260422033952.GG3518998@ZenIV>
References: <20260419161620.564854-1-jkoolstra@xs4all.nl>
 <20260422033952.GG3518998@ZenIV>
Subject: Re: [PATCH v2] vfs: replace ints with enum component_type for
 LAST_XXX
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal

Hi Al,

> Op 22-04-2026 05:39 CEST schreef Al Viro <viro@zeniv.linux.org.uk>:
> 
>  
> On Sun, Apr 19, 2026 at 06:16:16PM +0200, Jori Koolstra wrote:
> > Several functions in namei.c take an "int *type" parameter, such as
> > filename_parentat(). To know what values this can take you have to find
> > the anonymous struct that defines the LAST_XXX values.
> 
> To find _what_, again?
> 
> > I would argue
> > that the readability of the code is improved by making this an explicit
> > type.
> 
> Do argue, then.  How does that improve readability?

It is certainly in part a matter of taste, so I certainly won't say this
is "wrong."

There is the matter of type safety, and the (possible) benefits this entails
such as automatic case coverage checking for switch-statements. However, I don't
doubt for a second you aren't aware of this, so that probably won't convince
you :) . We indeed also don't do this for flag-types, but at least that
is a kernel-wide established pattern (now I am curious how the Rust people
deal with flags).

What I find somewhat unfortunate is that if I am looking at
__filename_parentat(), for instance, the signature does not give me any
clue what the purpose is of int *type. Then I look through the code and see

		*type = nd.last_type;

and I have to jump to struct nameidata and it still tells me nothing. I have
to grep last_type in nameidata to see it is used in conjunction with the 
anonymous enum.

I can only tell that it would have slightly decreased cognitive load and jumping
around for me when I first looked into namei.c. How that compares to some churn I
can't say.

> 
> What I see is a lot of churn.  Incidentally, I'm not at all sure that we
> should expose those outside of fs/namei.c - if you look at the sole place
> where any of those are used anywhere else you'll see this:
> 	err = vfs_path_parent_lookup(filename, flags,
> 				     path, &last, &type,
> 				     root_share_path);
> 	if (err)
> 		return err;
> 
> 	if (unlikely(type != LAST_NORM)) {
> 		path_put(path);
> 		return -ENOENT;
> 	}
> with the only other caller of vfs_path_parent_lookup() being
> 	err = vfs_path_parent_lookup(to, lookup_flags | LOOKUP_BENEATH,
> 				     &new_path, &new_last, &new_type,
> 				     &share_conf->vfs_path);
> 	if (err)
> 		goto out1;
> and having no uses of new_type whatsoever.  Smells like missing
> check _and_ wrong calling conventions...
> 
> Do we ever want to allow anything other thant LAST_NORM in any of
> the users?

I agree with you and Amir. The naming is also a bit confusing. Maybe, I am
confusing myself but path_parentat() seems to return the parent component of the
pathname passed into nd, not the parent of the resolved path, and these do not
have to be the same if last_type isn't normal. I presume that is why they put
that check into vfs.c.

So what do you think is the best place to move 

 	if (unlikely(type != LAST_NORM)) {
 		path_put(path);
 		return -ENOENT;
 	}

to? path_parentat() or filename_parentat()?

And thanks a lot for taking the time to review, Al, I appreciate it :)

Thanks,
Jori.
