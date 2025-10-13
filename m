Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C89F2BF009
	for <linux-cifs@vger.kernel.org>; Mon, 13 Oct 2025 14:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.134.164.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367048; cv=none; b=cdVIOnt9c7fkyqT3iuixqOZvMoczOKMgOh2y/ILOJ7HPmVBFxE851NQL1ekU7jhrpvk3ZYQuGjiek2lYvQ7MHUddUZanJFix3mkmhdYjx7pD4zIkyQKbPGqJOzutYYqDFFEYnW3yobzOAB4GmGbnFTeTpAzIlnREDJfEcWyeB8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367048; c=relaxed/simple;
	bh=tv420yr54IGx5wad+qpuj37I9o6HirgVE9boHJQ+dWU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=tldOvPRswEwDVV8vGKVADASMeONyGmqPzn/D0x5uU1TeGYJOJpht9K414ssJQrbfO8ohmzDLOM/Ck9XaFp0BdY3yvslPLVcwgiKFhiDyRdM8Lf1He/CHDw3cqgXgEPv/mvMjtYcu395qoc12avT89AzvDvlSehThoLaO5B4AXyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr; spf=pass smtp.mailfrom=inria.fr; dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b=KvMr5ajp; arc=none smtp.client-ip=192.134.164.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inria.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b="KvMr5ajp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=/KSGh+mz1eb7Y8G+KxS/eYv2a9owUNpbOQ1PhTDWdKA=;
  b=KvMr5ajps0lMsstnqNnIiV+mwheM9xCWDqk5MTbSdWAjLflwwttT9ifT
   geVBv4YzcNIIq69TC4UdDPCjrpEtt94QKzg20KVtn8KzC5viWgxYzS4JQ
   bXdHZKo0IfTclTGXSMx0QDwCuU5h9p0XdxBu0tN6s46vjVkH3SFKJusEs
   o=;
X-CSE-ConnectionGUID: snjf87YOR5q4s1+MPM3jyQ==
X-CSE-MsgGUID: dUvK5BosRYOuCeyUGjvDyg==
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=julia.lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.19,225,1754949600"; 
   d="scan'208";a="128049442"
Received: from bb116-15-226-202.singnet.com.sg (HELO hadrien) ([116.15.226.202])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 16:49:33 +0200
Date: Mon, 13 Oct 2025 22:49:28 +0800 (+08)
From: Julia Lawall <julia.lawall@inria.fr>
To: Markus Elfring <Markus.Elfring@web.de>
cc: cocci@inria.fr, linux-cifs@vger.kernel.org
Subject: =?UTF-8?Q?Re=3A_=5Bcocci=5D_Improving_source_code_parsing_for?=
 =?UTF-8?Q?_=E2=80=9Cfs=2Fsmb=2Fclient=2Fdir=2Ec=E2=80=9D=3F?=
In-Reply-To: <8480276b-ee1e-454e-954f-b25890c79add@web.de>
Message-ID: <dcfb5c63-ce1a-f487-df23-cadef6c45a32@inria.fr>
References: <335b0fe9-313f-4e3d-a01d-1954f3c46489@web.de> <805f36f6-ea15-cbc9-f510-45856eb6f6d7@inria.fr> <8480276b-ee1e-454e-954f-b25890c79add@web.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-107936897-1760366974=:3281"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-107936897-1760366974=:3281
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Mon, 13 Oct 2025, Markus Elfring wrote:

> > If you want the problem to be solved, please make some effort to narrow it
> > down to a smaller number of lines. …
>
> How do you think about to improve data processing for another source file example
> like the following?
>
>
> static int my_test_condition(void)
> {
> #ifdef MY_CONFIG_LEGACY_OPTION
>  if (0)
>     {
>         my_log("working?");
>     }
>  else
>     {
>         /* Test comment */
>     }
> my_info:
>  if (0)
>     my_log("reminder!");
>  else
>     {
> #else
>     {
> #endif
>      my_log("special part");
>     }
>  return 0;
> }

Thank you for the more understanable example.  I think it should ignore
the code under the #else since parsing is not successful when that is
taken into account.  I will try to look into it at some point.

julia

>
>
> Questionable test result (according to the software combination “Coccinelle 1.3.0”):
> Markus_Elfring@Sonne:…/Projekte/Coccinelle/Probe> /usr/bin/spatch --parse-c test-ifdef-legacy3.c
> …
> PB: not found closing brace in fuzzy parsing
> ERROR-RECOV: found sync '}' at line 23
> …
> parse error
>  = File "test-ifdef-legacy3.c", line 24, column 0, charpos = 282
>   around = '',
>   whole content =
> badcount: 22
> bad: static int my_test_condition(void)
> …
> bad:  return 0;
> BAD:!!!!! }
> …
> nb good = 0,  nb passed = 3 =========> 12.00% passed
> nb good = 0,  nb bad = 22 =========> 12.00% good or passed
>
>
> Will similar test cases trigger more desirable improvements?
>
> Regards,
> Markus
>
--8323329-107936897-1760366974=:3281--
