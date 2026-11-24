Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795483264;
	b=OsiwFj6wd/boJTWrN99FX7e563fIZqtVaWipBy5yP9TU9x1xWqr+0jaoGvcAimbzrGFg
	 pRgMMr8Tn7coDlTWuU/jB2b+E92XetsWfl/04RZ1bdTYAUBp/NoOpMRw+egGQcdT3dFjd
	 RIlUB2j8nAyMn7GDkQB50QYQT4bFH4IShW1QbJJiJ/aScvxQhdm7KiUxlYT1uvyba+hoy
	 aF5xlIufEQ+n0iSr5/mTdfeQXLUNpBrU27gLYse273hsR9dk5dHL71UNCeJqzn38T+cAt
	 otXQogfZ/4xs0PQsZkk7GW+s/urhehcsQJ6/I+/8vmD1CeVUAYdgML+u1AOSJlArhNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795483264;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=9BDulXHaTFH9WUerzen4hwlWxTAC3ppvvJGAoF+motE=;
	b=op6KFcKEav1+BuRFaMvYval/e1sZK/zU8ZigS5qPeW3Fne0cYEHLilzytNjTM+hwJ4It
	 ltHc/JO+q3dRQNfgGSCf0TRQP7IIoi5rqNuty7itJ9oKNI/aA5pJxqIESgjvfELM/dVXB
	 rne2hbmZfL4VMSndLhNvUJkkaeJZI8sBpdn6dSNEh4NTBswqGl4hWzmvSNjXj0ysHFk6s
	 ZpGVC/yB1R5WkqFmXXjv0co/pMR6YM3OH1Fz426Px23ZBXZ1O5FCRzq6fi/1g9lJkNPQt
	 u1qsQ5/aIf73xh1YVlvaf8OHqYIlqoyIkVSLwUtNnxuiGsiuGgs4tqr9YNUz49lmQdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bkne1S9o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31BB606A31E;
	Tue, 24 Nov 2026 01:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bkne1S9o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740841F000C0;
	Tue, 24 Nov 2026 01:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795483263;
	bh=9BDulXHaTFH9WUerzen4hwlWxTAC3ppvvJGAoF+motE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=bkne1S9okR19YKrKDubvz0IUMj2gGJv58KhVJgv/j0c8GqH2EiN3J3sfzmUkWtnKn
	 C/9tbQI2SoZGxOVEFBNj0W/imvtwJQu2oSlqdakV+Em7sinwEP7WLIPKl7GjJITkpT
	 2l5AUIv0iWo58eYIZcl5H+zOZmGBOYBOxry2wLevzl89WY3q8+4kZ+3ygPzycETtDe
	 EiNY1YHalsxE6Srkp7f26GaeMNuKEz4q0xSTcjsmh4clf8az3eN1UDNKWSX2dWumyM
	 j/IX6V+v4kkMg60RA37GA+3L+2VVDEYexKOtU/mXa3my2zJL5td5ce5PtPsToCj8Tv
	 ouxs2U1C47MVA==
Subject: Re: [PATCH net-next v19 01/15] net: define IPPROTO_QUIC and SOL_QUIC
 constants
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net,
 kuba@kernel.org, edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org,
 metze@samba.org, mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com,
 dreibh@simula.no, jamie.bainbridge@gmail.com, linux-cifs@vger.kernel.org,
 pc@manguebit.org, linkinjeon@kernel.org, tom@talpey.com,
 kernel-tls-handshake@lists.linux.dev, cel@kernel.org, jlayton@kernel.org,
 steved@redhat.com, hare@suse.de, aahringo@redhat.com, dhowells@redhat.com,
 matttbe@kernel.org, mail@johnericson.me, xiyou.wangcong@gmail.com,
 alibuda@linux.alibaba.com, jbaron@akamai.com, illiliti@protonmail.com,
 sd@queasysnail.net, marcelo.leitner@gmail.com, daniel@haxx.se,
 andrew.gospodarek@broadcom.com, mef@scarletmail.rutgers.edu, paul@jakma.org,
 kuniyu@google.com
Date: Tue, 24 Nov 2026 01:21:00 +0000
Message-ID: <179548326096.3135.1557496253047696896@kernel.org>
In-Reply-To: <ba1d4f03926411d4e61a7587e41a12b0b423d841.1795393691.git.lucien.xin@gmail.com>
References: <ba1d4f03926411d4e61a7587e41a12b0b423d841.1795393691.git.lucien.xin@gmail.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] This patch edits the tools/ copies of the kernel headers
  directly: tools/include/uapi/linux/in.h (adds IPPROTO_QUIC = 261) and…
- [Low] The commit message does not mention the change to
  include/trace/events/sock.h.

--

net: define IPPROTO_QUIC and SOL_QUIC constants

This commit adds the IPPROTO_QUIC (261) and SOL_QUIC (288) constants for
the in-kernel QUIC socket implementation. It also adds IPPROTO_QUIC to
the inet_protocol_names trace enum mapping. The tools/ copies of in.h
and socket.h get the same definitions.

> diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
> index b5310439536e0..ed43fe6d2705b 100644
> --- a/include/trace/events/sock.h
> +++ b/include/trace/events/sock.h
> @@ -20,7 +20,8 @@
>  #define inet_protocol_names		\
>  		EM(IPPROTO_TCP)			\
>  		EM(IPPROTO_SCTP)		\
> -		EMe(IPPROTO_MPTCP)
> +		EM(IPPROTO_MPTCP)		\
> +		EMe(IPPROTO_QUIC)

[Severity: Low]
This isn't a bug, but could the commit message mention this change?

inet_protocol_names feeds the TRACE_DEFINE_ENUM exports and
show_inet_protocol_name(). That helper is used in the TP_printk output
of inet_sock_set_state, inet_sk_error_report and the sock_msg_length
class. With this change those events print "IPPROTO_QUIC" instead of a
raw 261, and a new enum is exported to trace parsers.

The commit body only describes the new UAPI constants. The tracepoint
change is noted only in the v15 changelog below the "---" line, and
that text is dropped when the patch is applied. A one-line note in the
body would cover it.

>  
>  #define tcp_state_names			\
>  		EM(TCP_ESTABLISHED)		\

[ ... ]

> diff --git a/tools/include/uapi/linux/in.h b/tools/include/uapi/linux/in.h
> index ced0fc3c3aa53..e4072152f2e62 100644
> --- a/tools/include/uapi/linux/in.h
> +++ b/tools/include/uapi/linux/in.h
> @@ -85,6 +85,8 @@ enum {
>  #define IPPROTO_RAW		IPPROTO_RAW
>    IPPROTO_SMC = 256,		/* Shared Memory Communications		*/
>  #define IPPROTO_SMC		IPPROTO_SMC
> +  IPPROTO_QUIC = 261,		/* A UDP-Based Multiplexed Secure Transport */
> +#define IPPROTO_QUIC		IPPROTO_QUIC
>    IPPROTO_MPTCP = 262,		/* Multipath TCP connection		*/
>  #define IPPROTO_MPTCP		IPPROTO_MPTCP
>    IPPROTO_MAX
> diff --git a/tools/perf/trace/beauty/include/linux/socket.h b/tools/perf/trace/beauty/include/linux/socket.h
> index b17fdb7d38a77..7677133953ecf 100644
> --- a/tools/perf/trace/beauty/include/linux/socket.h
> +++ b/tools/perf/trace/beauty/include/linux/socket.h
> @@ -401,6 +401,7 @@ struct ucred {
>  #define SOL_MCTP	285
>  #define SOL_SMC		286
>  #define SOL_VSOCK	287
> +#define SOL_QUIC	288

[Severity: Low]
Should these two tools/ hunks be part of this patch?

tools/include/uapi/README says:

  So its important not to touch the copies in tools/ when doing changes in
  the original kernel headers, that will be done later, when
  check-headers.sh inform about the change to the perf tools hackers.

tools/perf/check-headers.sh tracks both include/uapi/linux/in.h and
include/linux/socket.h. The perf maintainers normally sync these copies
in their own tree and check that the beauty scripts still parse the new
definitions. Editing the copies from the networking tree skips that
check and can lead to duplicate or conflicting syncs.

The commit body also doesn't mention the tools/ changes. They appear
only in the v15 changelog below the "---" line.

Would it make sense to drop the tools/include/uapi/linux/in.h and
tools/perf/trace/beauty/include/linux/socket.h hunks, or send them as a
separate patch to the perf-tools maintainers?

>  
>  /* IPX options */
>  #define IPX_TYPE	1

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1795393690.git.lucien.xin%40gmail.com
