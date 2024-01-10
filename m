Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D57F4BAB5;
	Wed, 10 Jan 2024 16:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RG4lNkjW"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5571e662b93so3716318a12.2;
        Wed, 10 Jan 2024 08:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704903630; x=1705508430; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GiGQ3HzqRw9BhGq2ukZfu7U4Ux6Gx0fec0Z0CywCxtU=;
        b=RG4lNkjWWdnPtqE+8AEccWeqIEicxZTP8bCadI2UA8+WX3FKFYA1aOVZgzXM3n1giS
         t4Wf24pJXo44G1IgwOB2v0y/oqJSJKuDaa7AjMVGGSGkvJl70ZWlknUBy0g/JOrG7549
         nTlq27CjrPoaDM7KAezNsNmS4Q2fUKg92CX3i3jc+ItpQ9T1aaAM0W6/Afkm78GXK9qv
         Zik7DEI3z7eyfwAZwrrkOaKtBOGSte+2fFUXGore9JnuYfkxAXkNsCt84fUaHxisGx4e
         r5CsT1uBSgk4uqrnJaMWFTZRVBMOapXg9N8lX5QpsW/8TRBZdz1Wv64XDnu4cxYUHsvY
         xYsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704903630; x=1705508430;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GiGQ3HzqRw9BhGq2ukZfu7U4Ux6Gx0fec0Z0CywCxtU=;
        b=fqYn002n9nOmdG4pBKWmejKR0wIh2ssUoQUpgQI/xLRaBnZxdfq5gvFqISvyV4yEWk
         w0llMZrkGNy2rZCYiDAJBJJuDZChDYotL3Pi1tL3Gehsda3c2DwctU5pCjqoWOK8lBSM
         l3LahjSzzq0PAoCPBnDqb6hfIkHHCTPCY1FVV06XLbOKxjvxSFzmgnGdGNwTXPnsz7/N
         Eb4GPLh66dhe28PCiWKoUe6LUeMCAWQJJDCSUXXSm5FkwQb6h9/PwpXjsA6Iio+Js7hF
         YCVb+2XIyae6K/wev2cfKns5eIZwa3fztHbEgTXm6Jsstv7j9E0CKPy3CqS7Wccncmp/
         L0kQ==
X-Gm-Message-State: AOJu0YzLgMqw7w3cBjtZqk81FwOAWCsvf/vRA+Y8qd9e2ntirpFfrvdv
	pvkQYcctU46KsaTwkfa5eP8=
X-Google-Smtp-Source: AGHT+IHIX8ycHGd0EqT2+MdwAY36uRF5Dgt9eDaeEe5o8UpwwsXB+tUmydMpiBcVjI8SP8rgJa9KIw==
X-Received: by 2002:a50:9e87:0:b0:557:ba20:839 with SMTP id a7-20020a509e87000000b00557ba200839mr643069edf.41.1704903630339;
        Wed, 10 Jan 2024 08:20:30 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id ig15-20020a056402458f00b0055871ed18f9sm390720edb.89.2024.01.10.08.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 08:20:28 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 0525EBE2DE0; Wed, 10 Jan 2024 17:20:28 +0100 (CET)
Date: Wed, 10 Jan 2024 17:20:27 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <nspmangalore@gmail.com>,
	Rohith Surabattula <rohiths.msft@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Steve French <stfrench@microsoft.com>
Cc: "Jitindar Singh, Suraj" <surajjs@amazon.com>,
	"rohiths.msft@gmail.com" <rohiths.msft@gmail.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"stfrench@microsoft.com" <stfrench@microsoft.com>,
	"pc@manguebit.com" <pc@manguebit.com>,
	"jlayton@kernel.org" <jlayton@kernel.org>,
	"nspmangalore@gmail.com" <nspmangalore@gmail.com>,
	"willy@infradead.org" <willy@infradead.org>,
	"stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
	stable@vger.kernel.org, linux-cifs@vger.kernel.org,
	Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Re: [Regression 6.1.y] From "cifs: Fix flushing, invalidation and
 file size with copy_file_range()"
Message-ID: <ZZ7Dy69ZJCEyKhhS@eldamar.lan>
References: <2023121124-trifle-uncharted-2622@gregkh>
 <a76b370f93cb928c049b94e1fde0d2da506dfcb2.camel@amazon.com>
 <ZZhrpNJ3zxMR8wcU@eldamar.lan>
 <8e59220d-b0f3-4dae-afc3-36acfa6873e4@leemhuis.info>
 <ZZk6qA54A-KfzmSz@eldamar.lan>
 <13a70cc5-78fc-49a4-8d78-41e5479e3023@leemhuis.info>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13a70cc5-78fc-49a4-8d78-41e5479e3023@leemhuis.info>

Hi

Sorry if this is to prematurely to ask already again.

On Sat, Jan 06, 2024 at 01:02:16PM +0100, Linux regression tracking (Thorsten Leemhuis) wrote:
> On 06.01.24 12:34, Salvatore Bonaccorso wrote:
> > On Sat, Jan 06, 2024 at 11:40:58AM +0100, Linux regression tracking (Thorsten Leemhuis) wrote:
> >>
> >> Does this problem also happen in mainline, e.g. with 6.7-rc8?
> > 
> > Thanks a lot for replying back. So far I can tell, the regression is
> > in 6.1.y only 
> 
> Ahh, good to know, thx!
> 
> > For this reason I added to regzbot only "regzbot ^introduced
> > 18b02e4343e8f5be6a2f44c7ad9899b385a92730" which is the commit in
> > v6.1.68.
> 
> Which was the totally right thing to do, thx. Guess I sooner or later
> will add something like "#regzbot tag notinmainline" to avoid the
> ambiguity we just cleared up, but maybe that's overkill.

Do we have already a picture on the best move forward? Should the
patch and the what depends on it be reverted or was someone already
able to isolate where the problem comes from specifically for the
6.1.y series? 

Regards,
Salvatore
