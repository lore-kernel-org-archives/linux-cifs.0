Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137831548C
	for <linux-cifs@vger.kernel.org>; Sat, 11 Oct 2025 14:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760191523; cv=none; b=r36N4hv1QCxLNKjhJ68vHozJZm/Fkd6SZ/wifdtCdiRcnlE+Z4KPQ5hIaI8mDoFNqUZZQzOeWGf3+O9UbDAFPl53feWsHi5a+sp3qCsJ4RAtThI1d9le+BE96++qXVxpaqboHdkGrJHoIj/vvFK2tLSJYuyUIELxWCSQjgmtRVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760191523; c=relaxed/simple;
	bh=cCLRCsl+ubv+ujPGZt3kbB1IYCZIObalg2ThqCaBNpE=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=fGNIUQtDqHM6z/aHzFPxkZq68EGgc0GJisI3lYLfdXKy/2WyNNecYgfoM6I9UHKNDYP0/BxcCUIR3F3G39sOm4Vp9iE2IPo+RCIfg210LDaZYlxZ44imrOZlVSPgD/BUzNLWAQ2LWvbU3A3fnDicawdLptXkTUCxqhItZ0CkfvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=NrtRjims; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="NrtRjims"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760191519; x=1760796319; i=markus.elfring@web.de;
	bh=eGMiRWSm2YNTRobMRHY/QrAuxojGhIcf/jx36myw29w=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=NrtRjims3bAKT4N4loj7HMES91mSkm52O0Vwr2JmcFDnKZjYW2svEzHKtKVvLZXs
	 H62qGhHG2/4LpKZOlNiq9L/aLW1XJiLDghTPXq3nkCP1yHZUsWPPqpeBolUD2LaYl
	 fX6+QgRlyCvnrSrAjazBTcF6go5txwQ35NgVY+ziAftenm0R1UzI8cI1zG9CDuLXc
	 5hzrPkfPcoUDiim0+YsFtuVkfpn1xs7YmASnUmPSWfFjHjleZ17Tt7qkFqmBjwpWA
	 W385SC3GQV1HmqW4vfwAOUB72StkA3lLVKBcaBAU2u3rfiLxh75LokQZ54AegZtDA
	 YYlYFCaFGbG3JnV9VA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.253]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N30dV-1u7Cde00zd-0136I0; Sat, 11
 Oct 2025 16:05:19 +0200
Message-ID: <06e01da1-cdc0-4be3-b74d-fe12da890c1a@web.de>
Date: Sat, 11 Oct 2025 16:05:18 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-cifs@vger.kernel.org
Content-Language: en-GB, de-DE
Cc: samba-technical@lists.samba.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [bug report] Avoiding reserved identifier violations
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:qnWuS9+q8h2wRg2uPN5HVZsUKUco3U9rMQu+/vwyxOuYJ0tuGai
 r18Wn92LWmSKFo0sS2v9TikAVmAJwasj+GYyLCx04PO/H0a7/SfRIvDynMu5kq0b4HAxzHY
 4CqSso+cieDJNbHraURxHIekE9DdXFzcoeXQNdwWvKfP+zV/qYiABWqiIzqilD/j0fHlqcC
 uyxvM+3ZmO+Y+dSJUStMw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:76zvo62jgtQ=;dOO78x1HHTa3orh4nFgzz3dX2Ns
 9IzC/0xu6at/EdyYcbz09EvUcgnhcuxoOTMLLPi19G4+qtJAqGCy18XbtgtMnVwDpzYiVEULV
 ix4FbgcDoWX9O2Bypwu8qXcDzwY3uvXyX2HA4Eokr/Q21FPT+sQEG97tXIFkBvhq2p8j2R9sU
 +EPVgyTRricr1gLCw+66+RWoG8Onx6V5UCLm98zPHfvN+nW5ETHr5KDzgCNuhHQ8WNfC4LiXB
 4F989yXdVYb3Gd6FjHkahoLCa5JkpOBGinhGFJny/ea1LLQDDrKpO1AazP8Q4/3xDBY7PHl6b
 XVbjDvERUXg/lG/LO4cRE7ntu4IqOz8bOdiJ+fUjXBjJ+M72A5H28gww+oSbRvEZehUPevqPr
 SmAjXLkFTF4KSyWkUk59FFbLxH8Qm1ewpqEwQtBCVMGQQ4dGtVj20aF2LjvR3eT85KMAAKdBI
 wrk3ofpDpIJDZzmX+N7u5k8lBU1akiQrPGy/HK60EDFfGB6rBcIvgN1PEUwgQVUyE7S58IajM
 I9MF1R3He1VIHuq/ffEAUoooEfY6naAchWC3/M17n4fBPWfbkovL+eY6unwZB4UB78vfKxqmq
 eVSjf+dvx2JnXsslwDgayDJ886InA6xTzPcGOHvWhL1JdwHSLR3H1Ajs68azemgtB8dEXjkLl
 czhxQFbb28YuMJP+8yJojOWaVNthYPE6QzG7IabwEiZ+i8YpdGRuVq6OgHbTo6FUeH3nQrNLK
 0ajDakS/vfnOegsnfAqg3rpcGluOXmMRDz0q20A/qCH5TUDXmhek9jZkKhIgZSu4nOdYlZYSz
 hC4wphKsq6/0/Bcm8SB/7mzSTN+8Z6AGmkqj1bfCez5nb42PR0GMC2jBXC4LvTiupjkIXuXdG
 d4ip0lcVRdBH/v9PHZR6tLSfBGV9G1KF+Q9T8TqVy2+RG0/3c6CcNZNBfjv5vjqXTRZNM1y89
 SGIVLYRLHGKFyKhKvt9BVkQu+snb5TRooLN0mvj2pyQYl738Z3hbXf7ySjWAHR08ROCU1f3Y7
 0A6XbgFFPxvfzOTIy7nTXm5VhY2pBrFsmL5L/44QEvJS3GqUMAMMnV5zlz+nattr5vB+FazZT
 yXNx2SwGe9lYKcdST1WkqLB4SOV9nvrl4kG/8KtmgKM48nv+7tbNFWTkeCFA+F1aUrOn+nVRD
 I/ss1WKjsrs+WaEAq66/59X8fZNHZsEuf17nA1qRgtcTKqLpQgfbyNCrs1xs4ebvJzds+P1CZ
 cEAZ3M/DYMwiKYrJ65kINDBfIFyTggkFX3ZDpMIQP/5d0z/V5A337yxcGXO5NNd8I69j2VWJK
 mfhmy+slNTch4rAborVssWeoXbchMISru4vZvpq9rhEHCc3bBW4hBY1NLGhzXZ1U/3RBs9t9h
 JU8gmGHKAWggBwSjG5mhgziSqH8/A+2tReCE7lhHxYkTtz+tFlHV6PIanzsXgncqRrqJqmULN
 FiFsdCCkw31cXjnfNiiyLXf8X3ek8EWtXrRnz7jrO7aBszhh+RQv/YyuQeGzGH/zxAkbpvmM6
 hAYryhGhkKBQ05MgabqfZT+XIC0FU4Ui9ASeY7lxDGcNKew8EbbGsdPCHi20bJkFn2tuzPpKb
 OSJrENP/qz4X8eHQNTUuJHx0w7ocyyxJUcfSMw6aiuk5N/VhkreS+C70LkudYL4/sggiHJhkh
 zLXiwh4l+MeqfV8uTsXMajGNvt3ETcoay5UOce1m28lkmmdWZ0a48WLH1LkxhTDRL930OoSfO
 Ua/nEIhaN2UjZDIgw3WVC4LI12NLHFQLjMSZzZyvtjPELpRHbw/ULVRtaz/MZOgPLEc7SY0vm
 bqKQdUCcPojObtfpEzaJ/osBsyrLfSgFwR0G5Mly2sqjcKZXa3iMHGVBi7y4jnx/f8AHCWAiK
 L3av1PxBH2tToaE6QM5z1TkHgKw3dUbDi5av4F93VIkd4PpllERTrEVtpCVIXAGYTEPscp35N
 jdRqkXvUj5XLKH/QpK+oHUXbn7bs0U3NwEK4EXJzn4JKJVMxg7eyM7TVOnXyQ7geT1+MrcwZq
 78b/cUNx9YCfafDy7/8zuwrmpSPiUiQWoVBe60hM8HTiR5V6PRjEVc+vv1UkfPsLJ2s86MFsH
 2e4ngSPcHbYbJYpgZ/IqWyoXPuwFSdVw/0GoqleTzZJXa6oT6vswzqnEvlhnnBUYWfObLlwGs
 oYgLL3oe+svgmXU8RJI7fvJ2UNfKT4x5bywOHPiUrrk1+L2gHroCqUkp1NwBLVrDPaFgYlY1j
 PKfYQzX93xcw6oMt9UUuFERAWxOL4QnLgIfoBcF6VHIL0x3ZtVTGu3ZhdKhXlvkY9ggTmGK4N
 MKoRZl8hCH+Zlwsfr42Jy5iw2WDme1bgJvEiPTEFH57NkVg9/YoV4+r45oC7phB80HIqFf3a2
 b/zTiF1cO7Iw1xIwudIika4y2/WvLRrNL6jNquVE4SHwBc/kKmOWnew8FJCSgTMm/6HioJiaC
 NJrZTL37eqjafe7K2HqZt8N/NhbbFmdxuWm+oHLCLsXWAjXov9FXY+UUJxn4lwpUQMIfQZ4kJ
 YTD/dLKsyx3TkCjelTl+gnOdw/0tlX4W2x7N4M793uQD/k1jObxw6cHB5yeI1VIyEt/nFS4Ao
 vJKAfJOFPWtqey8lQs+Veij+3bg+TO9+HXBCFXY4XW04WBqLJgQjMKFixUU/XQnktElSCt0g6
 kR6TJd33+N3+IeqoWowjIRI84r45hxNpBZj7OM2A7kH/fbKLwdfPjlX2Bb6urHcX7scBcO+zP
 b3ff23XPfMq9HIcpi9p+Cm5wMTtcYVD/56xz0qRpbnIL/uZsXIYbOcAHvBiQEg9z7UCge9EA2
 4nxlVzc6f98w4YumCuJR+udRY4GOUHm2qH3f7tAM9+jPLZe3dlfAdOmdlDp56MKE2jCjf0NmA
 YzT0d9BTeqXzi+L6vYqRh4kOAfLy74yBJusMMPSUAVotfnyunUgXh9RnQHkkkALewaKWKDcy0
 cVZjOXKdfFmBBQ5dMCVy7dQN8lk2i00mSG4uV5FYP1NMpUmXfb651X0l8rq32YdN3Lg1gqZ7D
 TwcHoRoVncckQtrrh/7yiuRvI3TkU+zc0+OtDSc0dng3qO7Lal+vYXyvQyMIkAF+QVUh8H/Nv
 Jnnsu0KkyFn0JqwFkhLldoZmd50zpcVXZz8FBJyvrZV7mmcN/PI7WEeLA8NHipcsHdE57AGKQ
 /1SxAyz+gV4WYlWufujx4f9ew7ICU5vgyru9TmWQB+pm7ZTcedhLof7IlQKGOAbPNieFRY0XW
 BRv8lRTNKFz9e/6gCEe8OJfBsuJZJY5kC6yo/0YMlQv/Zz/gAyBFtLcBv8QacJjouFJFRz398
 dVage/7+8/LaFk5McN7nCAc3mQYC+5eJilyrEAGR9wXXhhuC2PEEPe+5eLmdYLA60SH9MN6EE
 T2pPMBsAL1M8cYoe4bXWNp4S4DAFKu1nam5C2d+bRXc6z5CIwZBThqdGMu79hwzkkfQQ0Yi07
 ePeyxCRsqdMoX/3guaVWQutW97IAj1nRl1V6ywlhHr8IGVQmhkXsatFwY6MeO5ICq0ZX8zHp2
 pOsICW5hgJ8iahigqvFeWn7nZVcgJuyyvORslWqV0UCWnOakxUZGKf0FVKbq7Sjrcx6PRY2EF
 74/i18NTPtxdJTM84s0692TLCdyj1RE0mAML8BNyQPORdUJ7mZoUQoxsK6uO5nqsxh/ZNdH/4
 /thxzYpuBTRvUh42USPr+3ZvdSJuq7urfWXGrCBcJ/ry8t/wtd2n92zeceatgNMA/S29UfjNo
 WmNpfU0coQOAQganUt7mOC9Wl9xrfWwVVZctECWWo0R8nw701K7fItqJX2fV2jHfJWk4O0NLy
 VP0szCFYVL8aR9Sr7/bSgyzc0/PSGB6RaPsqQNdZhXzCn609hikMa60zBxNy+ELxdG5CYmUqr
 963vsZZxvZ/mCLoTSup+S8na1Xa+Mh9ZAQH0CCppR8B0C5WHzOG62jbQu10lPDUzMuyErndis
 JHOpXNjFhXgCI5obe2YP32OWlezswnKwuuSEotRKtA/AVfbuCCidSWvwPTWpinti3FHEDfJs7
 k5/96t6SsuGG0nd8T02lATofwawSM/+88P/z7NHWEs2qVMzy9B8rv+ktUMXpL7DLY4/gQ42Ua
 BEE94OuEZpYCxxvfZDPMsfRwmWYjmJ3rJ2pV5krft3ssqNMZ07Bw/lp7jJcSuzjp4Ih9sgAde
 q5EireT35Fq/VB145sOHtquNP8zZGiLkvpGhSTe7otWzB/lSpBRkETKGZAP5/N5rnygSQCJ9x
 3E6Ung/EkoQ4cSYjEX3hv+St77aKnScJt8foKsL0qC8+68HV/gJ1oTO9GkoF2WhM4sas37Nc1
 NQkp4OU/cuwPGHEMYS5ieAhcCh0xTSS8zNfAAAk9wkVfDVfwpnvluGeH2J6EDNX1+mgiMBAbR
 QmYVqlBwrzEm5ctSK8skVzGGOJh/x7nCjIHHzGSeoxG5rz36Qq9txEJ0tXh2kCm7Y7tOIjIma
 zVaC6/nimZCjmGWdB8m9B5rJa9Ckp52HFWsMmOuLN5ThDpvQeWn3hpJd7jPQ56lIP1jaVAoSf
 Gk4Sd7umJnERvhkTA6vPe6BuHboZ+KmLF56Nsjg3d/J80xX8txYaK9Je8qPU0FepVrDZJhRlz
 HzY/3QoJTrxQ1e48mPuRE9s627Ci/OHsaGOO8kBFqa5tu7sW0LPYpplPzOgtpXh4MC1/MjGj/
 3ACWO2Lf3VkTUFHEl8g8ZLGpf9/78EMVpWoAEfm++nVM/7ubMF9/JJo/nXT+dlbkvd2M4Q+nW
 uZdZkFSwxasxh67guM4PTEAu7XyMk0iluNq9xzfGeUFXsa0gcnYf+GcVDZ5U0T+gnQhzu3Wl0
 C587mjhcW8cMiQENsE7MN3rmqtPavK3ObUOc0Du+MLoycCRrElvTQOolmlrLVMFwpcpJjCYVl
 w+nIvwTVKXujEt5A2bRDcWkSfxKhs+/e8T20TAErJDWzfdcm6xHexdtN3Pb8DpxBeAD8Ya4YF
 MuqLt7iRN8C8Q0skHsleotg3/E/upZ2LSWIbx5IcGdziuq10R890z/XLzqX/fDLRqBqLV0CzU
 nziXw==

Hello,

I would like to point out once more that identifiers like the following
do eventually not fit to the expected naming convention of the C++ language standard.

* _CIFSKEY_H
  https://git.samba.org/?p=cifs-utils.git;a=blob;f=cifskey.h;h=00694456e7f8a574d50c998501fa441b4230b0bf;hb=1561527e4b6192f6d47b85ea670637f771f5d52c#l20

* _LIBUTIL_H
  https://git.samba.org/?p=cifs-utils.git;a=blob;f=util.h;h=2864130f9246a87bd2f5118636a727f5dcecc01d;hb=e18d42adddbea9178d93b6051132f9cdee4cc9e0#l25


Would you like to adjust your selection for unique names?
https://wiki.sei.cmu.edu/confluence/display/c/DCL37-C.+Do+not+declare+or+define+a+reserved+identifier#DCL37C.Donotdeclareordefineareservedidentifier-NoncompliantCodeExample%28IncludeGuard%29

Regards,
Markus
