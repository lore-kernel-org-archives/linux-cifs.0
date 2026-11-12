Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794489007;
	b=GarTW7KzzHPi4zAR3MZqmsYdU1ai1ncxYCEqRSHuGUXfiwuGA7ov7R60Z8F9eKOka1CO
	 tZYdDgUoUgK/h9XbTYcnBHlV3YQbTHStcEvl/qlMQELEO0n4Gyirf8DHpXMPWVfpQekfk
	 9SiFSedtC0FJMmGWOVRnQ5gSaTvFpzrMCSCPhwGEaXekTP0FpIP9J4EAG/9GnOhG1y/e8
	 SZ7zjITRDOpMFqSJGbSJkk4CMs0IDQ1ZcGtpKbdzDnr6F2H9tgHmh7aqz7BqBf1Yxuygj
	 Bow2wY8ebkOVTtU9adbDW3jEqp4GrSDlWMHc+zyZCkJZp5JG5FotCS4FcYbOZHopfQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794489007;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:
	 Message-ID:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Correlation-ID;
	bh=eC1oHqixowa2dJ0VOR67ShJq1lsGUCMRNztFgjJLakc=;
	b=aUq4EKCOJ7dTkf4gihA3MilQt9gLuw2WMIQwxM8//0LShW5V24gDEiP2wa1zCvPi3HRV
	 VWovJbY4RCOG/5W/TnP9k7K3sZ5AeYlDHhFZ4IUpgl3+Akhy7XRiR+DMKrwLH4NEDiXn2
	 1fNvGlKRC8i3GMDu05JK6esd/dnrwaJBl4w9mELtrWddmqViEgDBRM7gylddRodUZwsAH
	 MfuFOgBzPrFEj1+CSV8SDTNM6JBtAqAusk2O8op/NRyGh0vWzo0IqMOLHKaMci00GUCKk
	 Djjg70QMWWhvML4fsFR7LJZ+1qnZbANCpews4Jh8LF/kPFwckJ//zeo/Fy6SUTvqS1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=W9BMceAF;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A9C606A89F
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 13:10:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42A9C606A89F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=W9BMceAF
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48e09aa5264so2443570f8f.2
        for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 05:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794489006; x=1795093806; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:subject
         :message-id:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eC1oHqixowa2dJ0VOR67ShJq1lsGUCMRNztFgjJLakc=;
        b=W9BMceAFLVa2ig4+J3cgT7USnK+QEUXBLoq63B1G0lAt+qgOHsN2yv9vjdKEo9mHwG
         IOOuTlmVcjIis8xWaA2NKfpPoOqpRQtzGcMh7jWv9Gkt0mOSmFjaJ94p3pFTkSKWT6ap
         0GiawZzb58q9RIoFj7T625DNcIokrL9TElY9QnmHrHYQOOAawX4XFEzWwIo9fqpL+uIi
         +f0cdrGFv5SuQCWc3ggwF2fA0GbG0sVz541RumHv/dMlA1cm4hyA52JmgVaeuzoKarZ5
         r/1N0B409vP65hy6opVG3/jFc+MTmtxZkWc9FeMkp2rCePnJlxHGxNuWfvakxpUlzuAC
         4S4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794489006; x=1795093806;
        h=content-transfer-encoding:content-type:mime-version:subject
         :message-id:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=eC1oHqixowa2dJ0VOR67ShJq1lsGUCMRNztFgjJLakc=;
        b=QPr5BcQWZ+IQmFHeiUUNdVhTJm5FyZGzS7Sazq2NjgDvDzGwVVeDdrQEe2APryNlHi
         y3x6F6wORs5edrvzdneWN2S/NwYPMVttAmMBBjZNIz3NXFLBFj4oKcDcnjyv/P9ZTg+2
         dEUua92DaKaYynswR8XjE3WNOXAeDHQyRXFKAKv7WmNq5zCFFqku2yypyboSmFzZIbIX
         C44kbwxKJwtzbS5A5oytcGGDeACew9SIEpkBXqJI6hCODrAdJ/qY3l1gqp/rkg2JMpr5
         FlW6x31qSQKEEFQNS69GmklCGW92TLE7CcHT5QPsw/Jc817Z0aeeiannVFV3ICxys+bd
         d5fg==
X-Gm-Message-State: APuU4Z8EuDnlWeyQhUnIFUnhxfi8g7MOzwwVIKQg/IpUol4wxhEdfTLZ
	6gMEdjeJCv5mYT9aegfw6FztubV9Yrhu6PRad9OGuPjXOo2RUGujZcLX0ibwkg==
X-Gm-Gg: AYBFou2e6yWFmqM97Y490xJFOKVX5c6fvjI6PhxbklNdP6INEWi/3SQivDvmG+xO0ox
	w+Kq0zp9GTQqFbIFVqv8J74pVyMyZ0GWhv1bd/zBKmmBXu3L2oSpbi9eYUluH+qXaZ+tqdYxbE2
	CVfvbJ89yg4Se5NMZfIdbc2sBl/ZVH7Mbl/y7oiNclc9Mj9Cj3fcwqgaPhPoR3a0BzPHDAOWxip
	YGa1gs6XXRX//K3UaqKVyR8iIZRMaT1ruc0TKGLhQSA0b3IBBvSTBcBfEQXfyW7dno4Ieggzg2K
	dfL2VFuoJkluE2e7h7XxLuaiG0oMDGktd/h7luMyM5mZbEAkbPXpDFjowpUmxRUzT3wTKNGAiCG
	t7GjDI9XAl6/1h3t3zKhM9NasAqR7bJPIv08xgTz00FWUB9KYrGsWMdfQaBBWkNTgYJu1jVfy2b
	6Y6xpk9IRtpg01Pbt2CsMAjLNUMRJ9eU1OxqoJMyzGQTgyHVzuLxiDfXencTHZfn4Gz1O1wLtDO
	VBYHODMJTG55d94+0UNytejlQJLOUiHK4GmRD6zaI1Q6TwZHM1i7Cg/RXFtsHUJfonr4inZO6yc
	NZdUgyV77AYgGwkQxGCh3PZx1eVppth+WAzFGSzvuNe1mvVF/PPtTQ==
X-Received: by 2002:a05:6000:4a13:b0:48d:f383:2356 with SMTP id ffacd0b85a97d-499c950a02bmr9434314f8f.53.1794489005471;
        Thu, 12 Nov 2026 05:10:05 -0800 (PST)
Received: from ?IPv6:::1? ([2a01:599:31a:21ff:56d8:1fd1:45e4:620f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49836c83432sm15571320f8f.58.2026.11.12.05.10.04
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 05:10:05 -0800 (PST)
Date: Thu, 12 Nov 2026 14:10:01 +0100
From: Felix <felixfranke95@gmail.com>
To: linux-cifs@vger.kernel.org
Message-ID: <bac15258-5b13-4449-a026-bdf5b17a25e6@gmail.com>
Subject: Krb5 Cifs Mount False IDs
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <bac15258-5b13-4449-a026-bdf5b17a25e6@gmail.com>

Hello Folks,
I hope that I am somehow=C2=A0 correct to use this channel.

I try to use Autofs Maps with Wildcards to mount a network share as a home =
folder as soon as the user logs in.
The maps are provided via AD.

SSSD is implemented to and works like a charm since I am able to authentica=
te the users. The Command klist shows a keytab.


If I do it via the mount command it works as expected. Since I am able to d=
irect the mount process to the proper ccache file.

But If the cifs.upcall is triggerred it only "finds" the wrong ccache File.

In the Gnome Case its always _42

OS: Oracle 9.7
Cifs.upcall: 7.7
Here are some logs and the fsmap:

-fstype=3Dsmb3,sec=3Dkrb5,vers=3D3,noperm,rw,cruid=3D$UID,uid=3D$UID,user=
=3D& ://sharedhost/Profile$/&.v6

/etc/request-key.d/cifs.spnego.conf
create=C2=A0=C2=A0cifs.spnego=C2=A0=C2=A0=C2=A0=C2=A0* * /usr/sbin/cifs.upc=
all -d -E %k

Nov 12 10:50:38 CV-04-test kernel: CIFS: enabling forceuid mount option imp=
licitly because uid=3D option is specified
Nov 12 10:50:38 CV-04-test kernel: CIFS: Attempting to mount //SharedHost/P=
rofile$/johndoe.v6
Nov 12 10:50:38 CV-04-test cifs.upcall[4481]: key description: cifs.spnego;=
0;0;39010000;ver=3D0x2;host=3DSharedHost;ip4=3D192.168.50.25;sec=3Dkrb5;uid=
=3D0x2a;creduid=3D0x2a;user=3Djohndoe;pid=3D0x117e;upcall_target=3Dapp
Nov 12 10:50:38 CV-04-test cifs.upcall[4482]: ver=3D2
Nov 12 10:50:38 CV-04-test cifs.upcall[4482]: host=3DSharedHost
Nov 12 10:50:38 CV-04-test cifs.upcall[4482]: ip=3D192.168.50.25
Nov 12 10:50:38 CV-04-test cifs.upcall[4482]: sec=3D1
Nov 12 10:50:38 CV-04-test cifs.upcall[4482]: uid=3D42
Nov 12 10:50:38 CV-04-test cifs.upcall[4482]: creduid=3D42
Nov 12 10:50:38 CV-04-test cifs.upcall[4482]: user=3Djohndoe
Nov 12 10:50:38 CV-04-test cifs.upcall[4482]: pid=3D4478
Nov 12 10:50:38 CV-04-test cifs.upcall[4482]: upcall_target=3Dapp
Nov 12 10:50:38 CV-04-test cifs.upcall[4481]: upcall_target=3Dapp, switchin=
g namespaces to application thread
Nov 12 10:50:38 CV-04-test cifs.upcall[4481]: get_cachename_from_process_en=
v: pid =3D=3D 0
Nov 12 10:50:38 CV-04-test cifs.upcall[4481]: get_existing_cc: default ccac=
he is FILE:/tmp/krb5cc_42
Nov 12 10:50:38 CV-04-test cifs.upcall[4481]: check_service_ticket_exists: =
unable to get client principal from cache: No credentials cache found (file=
name: /tmp/krb5cc_42)
Nov 12 10:50:38 CV-04-test cifs.upcall[4481]: get_tgt_time: unable to get p=
rincipal
Nov 12 10:50:38 CV-04-test cifs.upcall[4481]: main: valid TGT is not presen=
t in credential cache
Nov 12 10:50:38 CV-04-test cifs.upcall[4481]: krb5_get_init_creds_keytab: -=
1765328174
Nov 12 10:50:38 CV-04-test cifs.upcall[4481]: handle_krb5_mech: getting ser=
vice ticket for sharedhost
Nov 12 10:50:38 CV-04-test cifs.upcall[4481]: handle_krb5_mech: using GSS-A=
PI
Nov 12 10:50:38 CV-04-test cifs.upcall[4481]: GSS-API error init_sec_contex=
t: No credentials were supplied, or the credentials were unavailable or ina=
ccessible
Nov 12 10:50:38 CV-04-test cifs.upcall[4481]: GSS-API error init_sec_contex=
t: No Kerberos credentials available (default cache: FILE:/tmp/krb5cc_42)
Nov 12 10:50:38 CV-04-test cifs.upcall[4481]: handle_krb5_mech: failed to o=
btain service ticket via GSS (458752)
Nov 12 10:50:38 CV-04-test cifs.upcall[4481]: handle_krb5_mech: getting ser=
vice ticket for sharedhost
Nov 12 10:50:38 CV-04-test cifs.upcall[4481]: handle_krb5_mech: using GSS-A=
PI
Nov 12 10:50:38 CV-04-test cifs.upcall[4481]: GSS-API error init_sec_contex=
t: No credentials were supplied, or the credentials were unavailable or ina=
ccessible
Nov 12 10:50:38 CV-04-test cifs.upcall[4481]: GSS-API error init_sec_contex=
t: No Kerberos credentials available (default cache: FILE:/tmp/krb5cc_42)
Nov 12 10:50:38 CV-04-test cifs.upcall[4481]: handle_krb5_mech: failed to o=
btain service ticket via GSS (458752)
Nov 12 10:50:38 CV-04-test cifs.upcall[4481]: Unable to obtain service tick=
et
Nov 12 10:50:38 CV-04-test cifs.upcall[4481]: Exit status 458752


