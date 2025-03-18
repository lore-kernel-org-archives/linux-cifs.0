Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E689414B08E;
	Tue, 18 Mar 2025 14:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742308734; cv=none; b=DZV4RUK0HpFT8DSpUwdl7rIC3t+O5/PlC78KQ6eVp8mgEXBaNOZv343KX+VB/SoXoB1OCfxGqy2UKxMbu5n32vwDpheCejt5jmsSALNgkYqvVt6PgVw5HdSsp2NbiMD4TVm90Xh5NErx3xtH+Y9Lsyg3K7cuXvmOYb85X/EGzBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742308734; c=relaxed/simple;
	bh=4VKclmvpYB5sBLwzt4Dwv68mG1o6toDPjALwYO67dDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EcRhA4oinBAp2yzVa4Wv+om7Rkr/CewcVXd8PisEvJ6F+Fx00hVi5d7m9j5I4fca6gmtCls+gMLLYOuyrY8W3V+8wwPrduo68RhhVM1++9xWq94teq0QzcWs9N+UFP/n5AtqDmOupqkwnooLEjplZShLANz1jdwXpWQywL1ZX5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMHBTo6h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMHBTo6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5821EC4CEDD;
	Tue, 18 Mar 2025 14:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742308733;
	bh=4VKclmvpYB5sBLwzt4Dwv68mG1o6toDPjALwYO67dDU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OMHBTo6hlXQU7dVft10EP8yJE3VznGumEYNPjwcRLI8M7bgsJU8GwIdPcnCvT7IA/
	 zRCZ3yj3RuZN1MLGMD3Zakp95oraxXSz7kTBaXI8/Pr+/l02Vq/pvNCQShGu02iH+Q
	 fREc/SkfWMAKhsJTCNrc6SXyplZMcT7nns4lo6WI=
Date: Tue, 18 Mar 2025 15:37:35 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Wang Zhaolong <wangzhaolong1@huawei.com>
Cc: David Howells <dhowells@redhat.com>, Steve French <smfrench@gmail.com>,
	stable@vger.kernel.org, linux-cifs@vger.kernel.org,
	yangerkun <yangerkun@huawei.com>, yi zhang <yi.zhang@huawei.com>,
	Paulo Alcantara <pc@manguebit.com>
Subject: Re: [BUG REPORT] cifs: Deadlock due to network reconnection during
 file writing
Message-ID: <2025031821-ominous-sappy-18ad@gregkh>
References: <CAH2r5mv4N9zFOKTxwdvk6ahAyjgpYULQp8iw2NMu3eB6FEXh0A@mail.gmail.com>
 <3bd10acc-2d7f-019a-3182-82ab647bc15a@huawei.com>
 <3049256.1739192701@warthog.procyon.org.uk>
 <785a8d03-3ee6-4eb1-e72f-db05fc4fb49c@huawei.com>
 <ee68f83b-6bc1-7334-b7bf-19415ee7c453@huawei.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee68f83b-6bc1-7334-b7bf-19415ee7c453@huawei.com>

On Tue, Mar 18, 2025 at 09:50:25PM +0800, Wang Zhaolong wrote:
> Friendly ping.

Empty pings with no context are not good :(
