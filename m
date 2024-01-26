Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFEA1DFE4;
	Fri, 26 Jan 2024 19:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706296434; cv=none; b=nVZ3FbYI23g5Opfy9s1rGQHAj9/zWXkh3Xk4uUqwjiZ8N+QWkxOiTZuFRGUcDZA6VP9GFAUDVBpPvkJseVG2ndbgJxelLMdIn5aE1IpRDNtT2T5oGGqSKspCm52g4KXwLGTxEMVeAuuZU8ZfWuIyMDV9uaJOzusDkadvMf34Asg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706296434; c=relaxed/simple;
	bh=auOG/6WTlLMP42/ZwkTSWVSQm5vUsuTst6mpxgMIz24=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EKDgnBPMp6G26km/+vDSWHMMMBhmsyadmpPq3MimdycPsKLXaoAYl2BlN2eKXIU/Wmn5Qk3N5/cFaPmKnkS/kLgPdzh3p/QvsDADLYBSCW1yg0d/ZSZcUDDGBNowtRqCFGVQxuNwmcq3ruOJ6e65oujvsosm2GLqpfmHZGf96ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sYiauapo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sYiauapo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8E8C433C7;
	Fri, 26 Jan 2024 19:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706296433;
	bh=auOG/6WTlLMP42/ZwkTSWVSQm5vUsuTst6mpxgMIz24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sYiauapoWVGAe94yJ/y2zleJiqh8/VxTWLJf5qUxzbo9u9LvKVNSPluSJsGP29+Jm
	 SA46IgmcZFXsE61puOybnv4X4yuQBlWO20K0Mg9Qg/Ev+PgcYYZtHbtdgZyZoxNhTQ
	 EBNiTeHVIxvRO/R6BDMJPfePZTH22J+vxelMYbUwGkdBOnWwmX8M5IRIhNAkIpKVDV
	 NCtjtrsc9GrmnMRvBtOd6ssprkTqcFFAL1QxWzbX8mrvFwjZJuWnquT2dHxbLNPoky
	 O15F0Sc53QxcmnPbyoml86VtdL01Z4I2kW3YOmzqS8nDZrduteA75g6QmzZCgkgpkV
	 CM1nUizZMqyTg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>,
	"pc@manguebit.com" <pc@manguebit.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"leonardo@schenkel.net" <leonardo@schenkel.net>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	"m.weissbach@info-gate.de" <m.weissbach@info-gate.de>,
	"regressions@lists.linux.dev" <regressions@lists.linux.dev>,
	"sairon@sairon.cz" <sairon@sairon.cz>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with "Resource temporarily unavailable"
Date: Fri, 26 Jan 2024 11:13:51 -0800
Message-Id: <20240126191351.56183-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <53F11617-D406-47C6-8CA7-5BE26EB042BE@amazon.com>
References: 
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 15 Jan 2024 14:22:39 +0000 "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com> wrote:

> It looks like both 5.15.146 and 5.10.206 are impacted by this regression as
> they both have the bad commit 33eae65c6f (smb: client: fix OOB in
> SMB2_query_info_init()).

Let me try to tell this to the regression tracking bot, following the doc[1].
This is my first time using #regzbot, so please feel free to correct me if I'm
doing something wrong.

#regzbot introduced: 33eae65c6f

[1] https://docs.kernel.org/admin-guide/reporting-regressions.html#how-do-i-report-a-regression


Thanks,
SJ

[...]
