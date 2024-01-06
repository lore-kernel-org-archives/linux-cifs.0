Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6196FA6;
	Sat,  6 Jan 2024 11:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A+nCHRHZ"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5576ff28423so91526a12.3;
        Sat, 06 Jan 2024 03:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704540842; x=1705145642; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9Yf7LENhQSqenSscECwkvVs+MDQCFfBLSHrYitmyEzQ=;
        b=A+nCHRHZHvF2KCqaCBLto0+gAcNHLwaH62rdk74cI8mbLU8D/BweueNCj5Yz9r0UZ0
         h6x+/VLXycOoWqvhIsIb5wfBcF/Rs7ygRrDUmvIhcYGB3BvMbhpthjIWiykmB8bv5ivb
         rIz6U6sluokcqUmkj15fgehO1ZolWtA4jtrbpxFJZLaAH9nlJH5VSOQfelBvkQCVBQru
         /OMIXikxSNmT/jBPjBlgR9B795yncDp3okkIWK0CbTgJIqW3arfvkFeSYWONyjPUXfgj
         e1RjJsVAHKESFYYWo9MQXM4QjL0EfG7d4gqtXgxggf20erS5ciud8l5OZDeh2zFYjSTP
         vxsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704540842; x=1705145642;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Yf7LENhQSqenSscECwkvVs+MDQCFfBLSHrYitmyEzQ=;
        b=Aj8EBb1LFbqBQ0Up7EFzmIYHYfV6Na9zql6ppk/EcZe6h/hCf1IbF2fFOibg8zilu8
         bHS6Xq2iTqcuSP2AJpxbtbCfOFQxBz0I2ddnaF/k3+3fFEP6wN2W3I+dQoAjT+lNU1Pf
         uW7M/pL/Hy5v9zJou18W+Ch3Ghfs5WfqJeufVKSlFsLougL3UP4pZcYlhSZbiZ36uS/a
         uTNQQ+bDRJKNBORsbvQa/HWc4SONKtqdhvHiIuBt4v5bPm/UOUAUd6Rd/meZ4q60I85J
         iZ4NMBgeiJ8Z9+Veg3HBjLG52p8yfdOWF2wyqHW4GR0v60ZC7gBltH9pU3G1Vh4yqYIr
         mUuQ==
X-Gm-Message-State: AOJu0YwwVGRgXNhrOjBHrehbaz5NjRKB2YLZRKTmpeqY404ZnB0Yip9P
	eIVC62KJG8ZUSkW4TIa7GKE=
X-Google-Smtp-Source: AGHT+IG5Ec+Xjl/1zLe/Q4M2ZuntsvOhm9Pk2mEirugLidEvZOczFSbhZzcamtbqPwPx7hl+5Fn0vg==
X-Received: by 2002:a50:d602:0:b0:553:40bc:4eca with SMTP id x2-20020a50d602000000b0055340bc4ecamr408934edi.37.1704540842439;
        Sat, 06 Jan 2024 03:34:02 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id ef9-20020a05640228c900b0055751515a84sm749563edb.51.2024.01.06.03.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jan 2024 03:34:01 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 06CDABE2DE0; Sat,  6 Jan 2024 12:34:01 +0100 (CET)
Date: Sat, 6 Jan 2024 12:34:00 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Linux regressions mailing list <regressions@lists.linux.dev>,
	"Jitindar Singh, Suraj" <surajjs@amazon.com>
Cc: "rohiths.msft@gmail.com" <rohiths.msft@gmail.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"stfrench@microsoft.com" <stfrench@microsoft.com>,
	"dhowells@redhat.com" <dhowells@redhat.com>,
	"pc@manguebit.com" <pc@manguebit.com>,
	"jlayton@kernel.org" <jlayton@kernel.org>,
	"nspmangalore@gmail.com" <nspmangalore@gmail.com>,
	"willy@infradead.org" <willy@infradead.org>,
	"stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
	stable@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: Re: [Regression 6.1.y] From "cifs: Fix flushing, invalidation and
 file size with copy_file_range()"
Message-ID: <ZZk6qA54A-KfzmSz@eldamar.lan>
References: <2023121124-trifle-uncharted-2622@gregkh>
 <a76b370f93cb928c049b94e1fde0d2da506dfcb2.camel@amazon.com>
 <ZZhrpNJ3zxMR8wcU@eldamar.lan>
 <8e59220d-b0f3-4dae-afc3-36acfa6873e4@leemhuis.info>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e59220d-b0f3-4dae-afc3-36acfa6873e4@leemhuis.info>

Hi,

On Sat, Jan 06, 2024 at 11:40:58AM +0100, Linux regression tracking (Thorsten Leemhuis) wrote:
> Hi, Thorsten here, the Linux kernel's regression tracker. Top-posting
> for once, to make this easily accessible to everyone.
> 
> Thank's for CCIng the regression list and telling regzbot about the
> issue. There is one important thing that afaics[1] is missing and would
> be really good to know[2]:
> 
> Does this problem also happen in mainline, e.g. with 6.7-rc8?
> 
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>
> [1] I hope I didn't miss this
> [2] as explained here:
> https://docs.kernel.org/admin-guide/reporting-issues.html
> https://linux-regtracking.leemhuis.info/post/frequent-reasons-why-linux-kernel-bug-reports-are-ignored/#you-reported-a-regression-in-a-stable-or-longterm-series-without-checking-if-mainline-is-affected-as-well

Thanks a lot for replying back. So far I can tell, the regression is
in 6.1.y only and might indicate that some prerequisite changes (maybe
in the folio refactoring?) is missing. The commit identified by Suraj,
7b2404a886f8 ("cifs: Fix flushing, invalidation and file size with
copy_file_range()") from 6.7-rc5 was backported to two of the stable
series, 6.1.68 and 6.6.7.

I did not test mainline specifically (would need to first build) but
did test 6.6.9 based version and the problem is not reproduible there
(and neither with 6.6.10-rc1 which I have build for the RC series
review posting).

For this reason I added to regzbot only "regzbot ^introduced
18b02e4343e8f5be6a2f44c7ad9899b385a92730" which is the commit in
v6.1.68.

Regards,
Salvatore
