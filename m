Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB4419C542;
	Mon,  2 Feb 2026 14:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770043229; cv=none; b=GrRpjwmc7eRGN4NLCUxZpHeao/bOGzw+MUd89mHBKO7TPyKs7dH059cX6dLIp+I4kZz1qhMwDwHG3RN1rmsWcEz7dqmbsMrRsh8fnvfPAUTJDNZGDTqmbLpQdHv3/kMmXErve3rmlxQyf+j0v7mmbfLZTRJMh0eAyh1yRJFtIlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770043229; c=relaxed/simple;
	bh=z9H7kXgJv8O5Dr5aAZueedbfhhO5W0BpFzOg32hkY+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XKSyzuGo9d/p1mGsxEtu0c38n/4m3GHdFc5+Nfmm9Ct2dVCCdYFN4dim+nyhAbUbEFnZ/bxAGWUwW9D1iy4YVONTQaEq829YZ5m5/iJC92kxGgoTwOFpebXPkC6xthv4MSRXsOCMVdGjsH/WYmiDAJsKb/caufCwg4Hn7qh9y10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZvG6zmzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZvG6zmzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D879C116C6;
	Mon,  2 Feb 2026 14:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770043228;
	bh=z9H7kXgJv8O5Dr5aAZueedbfhhO5W0BpFzOg32hkY+c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZvG6zmzpIMtqRWhTI3ViHMhIxK7hMYJdSEHuLbBmpzDpA2Lz7SqUi/bzlAMczf3DP
	 cyWVGLlLpWbFSygzxv7aQIZDGF3xFigosSEd7nTa59B0NRj1IYrKAYg3+DlDbo+qgN
	 9IQJ3TZm/TkWFQhqyK4+F7F7/3bdCrT+S/TN3EFRty1Ln88JzD9+r3ByITPpL6fhE4
	 LLvj0LY2b6LbhhtU0B9F8H023MUM1IsWii8xTE1Kj5diV4niUsJg7rzKMaWxAbqpYr
	 4RygoB33pacXLnerfKZGCyLgyJtyLW4ueLHU6oKSqyYo1+CMlJUq2SKIoROONyAAGp
	 W5b/6V2bGBfFg==
Date: Mon, 2 Feb 2026 14:40:20 +0000
From: Simon Horman <horms@kernel.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: jlayton@kernel.org, davem@davemloft.net, daniel@haxx.se,
	kuba@kernel.org, dhowells@redhat.com, chuck.lever@oracle.com,
	andrew.gospodarek@broadcom.com, matttbe@kernel.org,
	tfanelli@redhat.com, metze@samba.org, marcelo.leitner@gmail.com,
	edumazet@google.com, linkinjeon@kernel.org, hepengtao@xiaomi.com,
	illiliti@protonmail.com, quic@lists.linux.dev, mail@johnericson.me,
	jbaron@akamai.com, alibuda@linux.alibaba.com, tom@talpey.com,
	steved@redhat.com, sd@queasysnail.net, pc@manguebit.com,
	smfrench@gmail.com, pabeni@redhat.com, netdev@vger.kernel.org,
	linux-cifs@vger.kernel.org, xiyou.wangcong@gmail.com,
	dreibh@simula.no, kernel-tls-handshake@lists.linux.dev,
	mbuhl@openbsd.org, aahringo@redhat.com, hare@suse.de
Subject: Re: [net-next,v8,09/15] quic: add congestion control
Message-ID: <aYC3VC_DflQvgWSO@horms.kernel.org>
References: <9b38b4291e2b1b47ee17f7247c4c66f5bcdccffe.1769439073.git.lucien.xin@gmail.com>
 <20260128161505.1454974-1-horms@kernel.org>
 <CADvbK_cNUg+N5jAnmJXGBri27+AkwuFFhbKUqONkAgu1ZAmOJg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADvbK_cNUg+N5jAnmJXGBri27+AkwuFFhbKUqONkAgu1ZAmOJg@mail.gmail.com>

On Thu, Jan 29, 2026 at 02:44:24PM -0500, Xin Long wrote:
> On Wed, Jan 28, 2026 at 11:15 AM Simon Horman <horms@kernel.org> wrote:
> >
> > This is an AI-generated review of your patch. The human sending this
> > email has considered the AI review valid, or at least plausible.
> >
> > For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
> > ---
> > quic: add congestion control
> >
> > This patch introduces quic_cong for RTT measurement and congestion
> > control. It implements a congestion control state machine with slow
> > start, congestion avoidance, and recovery phases using New Reno.
> >
> > > diff --git a/net/quic/cong.c b/net/quic/cong.c
> > > new file mode 100644
> > > index 000000000000..1a8b7f8db977
> > > --- /dev/null
> > > +++ b/net/quic/cong.c
> >
> > [ ... ]
> >
> > > +/* rfc9002#section-5: Estimating the Round-Trip Time */
> > > +void quic_cong_rtt_update(struct quic_cong *cong, u64 time, u32 ack_delay)
> > > +{
> > > +     u32 adjusted_rtt, rttvar_sample;
> >
> > [ ... ]
> >
> > > +     /* rfc9002#section-5.3:
> > > +      *   adjusted_rtt = latest_rtt
> > > +      *   if (latest_rtt >= min_rtt + ack_delay):
> > > +      *     adjusted_rtt = latest_rtt - ack_delay
> > > +      *   smoothed_rtt = 7/8 * smoothed_rtt + 1/8 * adjusted_rtt
> > > +      *   rttvar_sample = abs(smoothed_rtt - adjusted_rtt)
> > > +      *   rttvar = 3/4 * rttvar + 1/4 * rttvar_sample
> > > +      */
> > > +     adjusted_rtt = cong->latest_rtt;
> > > +     if (cong->latest_rtt >= cong->min_rtt + ack_delay)
> > > +             adjusted_rtt = cong->latest_rtt - ack_delay;
> > > +
> > > +     cong->smoothed_rtt = (cong->smoothed_rtt * 7 + adjusted_rtt) / 8;
> > > +     if (cong->smoothed_rtt >= adjusted_rtt)
> > > +             rttvar_sample = cong->smoothed_rtt - adjusted_rtt;
> > > +     else
> > > +             rttvar_sample = adjusted_rtt - cong->smoothed_rtt;
> >
> > The comment above references abs(smoothed_rtt - adjusted_rtt). Paolo Abeni
> > suggested using abs_diff() from linux/math.h for this calculation in v3
> > review, and it was acknowledged. Could abs_diff() be used here instead of
> > the manual if-else?
> >
> > https://lore.kernel.org/netdev/a9427359-a798-4f3a-88ef-c10a0bf614ec@redhat.com/
> >
> Wow, AI truly has a good memory.

Yes, I was surprised too.

> Right, I somehow missed this. will apply abs_diff() here.

Thanks!

...
