Received: from outbound.st.icloud.com (p-east2-cluster5-host10-snip4-10.eps.apple.com [57.103.79.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7429B3009C3
	for <linux-cifs@vger.kernel.org>; Thu,  8 Jan 2026 05:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.79.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767850198; cv=none; b=CPAlhgP1L/N+NHyBsI0ZLsq+3FpDFi7ydRxUVR4H9XiWFqWPyJNfgam2tSuIKPP8y6/4jfiKe2WoMG+Bl5HCSiVQHAiP+3raakEH3C7g0KDUMSfGoUuvtMwcZ9snKOrBqD3LQOXMVNSOSG5YhjRjR/K42ScfzXBfQeKQWwVzKvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767850198; c=relaxed/simple;
	bh=2nrC9ON/s98TK8hrLhynx3Bf0j7zwPrLAz2hw3a0AAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ho/ex4RlG1bI61OWQhsKI631n9LYjz954G6hdSWkY+jEIY3eJAgk0a7KZIdgOsxrGW1gzQZlqV195foNrRG2SDrt3HfRU2n2TvzHik1Q26xWxGH1m1YirFe9VL+Akc4gCCTPbT7uleJQ6eTchrtmx+mtYr76tehxeCwqf+flKkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=y-koj.net; spf=pass smtp.mailfrom=y-koj.net; dkim=fail (0-bit key) header.d=y-koj.net header.i=@y-koj.net header.b=s1VG2qNm reason="key not found in DNS"; arc=none smtp.client-ip=57.103.79.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=y-koj.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=y-koj.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=y-koj.net header.i=@y-koj.net header.b="s1VG2qNm"
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-13 (Postfix) with ESMTPS id 524C918000AE;
	Thu,  8 Jan 2026 05:29:46 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=y-koj.net; s=sig1; bh=Dlg+HZG+uryoi/er62isCjqyE07hM64Oi3KMdtV0Vc8=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=s1VG2qNmTGwoFYinrG9xICUFcSJXqZgl5VIcHc7NW05yxOKg6uKATNioVaRhTZnwddYfIpgK9asKpLn+a+ns00FnipvfnMkA76stUl/YgfXk0KRTlNwvp/HQg473Kp2TpJoP8J68JC0Og6UZGFWQbK+v6HcKu5x06Xt9I6M9kMrNssPBtlr4RDUi/C+QzipDo7XvsGYQGQU5zIiN+bs+yyrcYCmuM6afsHLi+gaNaeEz8bRbNy/9cctDAZKWVx87rZfdCuKGe+PS0R53WEjtTNKJ6116EREQ4674T9YvQTjm86WSiXWBbRdpGgfPGJrRiMKCd5NjTZKtQrJZqCviGg==
mail-alias-created-date: 1719758601013
Received: from desktop.y-koj.net (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-13 (Postfix) with ESMTPSA id 566B6180014E;
	Thu,  8 Jan 2026 05:29:39 +0000 (UTC)
Date: Thu, 8 Jan 2026 14:29:36 +0900
From: Yohei Kojima <yk@y-koj.net>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev,
	davem@davemloft.net, kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
	Pengtao He <hepengtao@xiaomi.com>,
	Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>,
	kernel-tls-handshake@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>, Steve Dickson <steved@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Alexander Aring <aahringo@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: Re: [PATCH net-next v6 05/16] quic: provide quic.h header files for
 kernel and userspace
Message-ID: <aV9AwNITeyL71INz@desktop.y-koj.net>
References: <cover.1767621882.git.lucien.xin@gmail.com>
 <127ed26fc7689a580c52316a2a82d8f418228b23.1767621882.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <127ed26fc7689a580c52316a2a82d8f418228b23.1767621882.git.lucien.xin@gmail.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDAzMyBTYWx0ZWRfX3w5oucX6KeMt
 J9LgQ7XsCfDa76U6T+d+SozwqIeDDVs9Wrb9zKHOQp/BBB53w8XdjraBF90aN9b/tb8ZH1Cw2MP
 szApF1cKLMEy4/mYPkBmKOiYku/vOH1CJwMOLt5zSWVjjKNoRqUmpY5t6ywC0J5cKatYRSLNc9p
 OWS68xeJmmIKNYAeIoak9iQ9YhOyDdSIR2Lz5UviNtuQ25xInIFA60vTsOhjoMIL+cHzDI2f/li
 LleVtbz9Oo6QYVeHN34oGcS4BU7UGY1YX1L9EfpOHmxvhX908UeYBMcVATNdfeRxH++faE6FG3a
 5nEixN3LYHyFuVVnXS3
X-Proofpoint-GUID: 9TZL-nSB0akxs2QiqYcxQE-0rUqP4sXt
X-Authority-Info: v=2.4 cv=Zqfg6t7G c=1 sm=1 tr=0 ts=695f40cf
 cx=c_apl:c_apl_out:c_pps a=YrL12D//S6tul8v/L+6tKg==:117
 a=YrL12D//S6tul8v/L+6tKg==:17 a=kj9zAlcOel0A:10 a=vUbySO9Y5rIA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=48vgC7mUAAAA:8 a=NEAV23lmAAAA:8 a=20KFwNOVAAAA:8
 a=hGzw-44bAAAA:8 a=pGLkceISAAAA:8 a=MC3a9TjT73Xyz1QdSpcA:9 a=CjuIK1q_8ugA:10
 a=HvKuF1_PTVFglORKqfwH:22
X-Proofpoint-ORIG-GUID: 9TZL-nSB0akxs2QiqYcxQE-0rUqP4sXt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-07_05,2026-01-07_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 suspectscore=0 clxscore=1030 phishscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 classifier=spam authscore=0 adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2601080033
X-JNJ: AAAAAAABDl42yeCwc+M8qcyuH70R2S0rVPqklgtjxks/eUu6TsIgIwsfu5o+1ekGTSNDwtDjU6TSdKfdEgkdqYQfv8GVKj3HSS8mpUR7nfoUoeHCs4WTOvVW4BHeKokRDE5CLyWjCMo0luX/TaUZNuhXSpkrQnhg4xZbumfnVmjeg4hD6LiCXtZYeUBb2pH8RHoymNThrV/DqXJz4VM9c+LJIghG82uG+7mfsS0+0Ev/ZP8lIvesm8U3iVw2UuJSsD6qB7kR/oKHCQcJLW95cVTUtuDVHCDiKQSLWyZEs8VgwzJFHTUyEGe1mhAzvUJyMDUrmMDY7V7rMLa5lLiruttU81XuN1RsBq4BqfTTzww9rEgwl65evMPLMCsCI7TPG02PNNO/yya0uJMk1jWPLed6TT4WLqRzo/PQeQAZPSNwVinWPVO6PNKXgzXh2AZrH7guo5wr0VX3/RLt1L3pwc6kj2NbQyeKo4X4It5zk5Lme0GA3aiWXpz6iplwVL/BMlttgQvKebDz6VISi8RI8K/DOIuHOT9IvDWjs+sDqPNEr43GyCCtsmLXDYyNu8C3coicxiF9iPJHupAH8crs0uzhSRf4v8g77qgnHaZPgzhKwJrAg5GVboZhlosJAD+FV7+wwbXZmU0rCG4sgHCtXLw8VkXYjincb7a5ZUlZ6cCfNGVACmn5lEGTCo/4xAOh/BTwTq4c3Qo922fVREQeFJ6FhyXKYJM7rp1Lwq3a6+OlLST862DvVL6hr/nhKUg7djU+IFtInx3mF7CWj8qaDnEvf7fbu48XMIoeAdSb/RXVtiNnMPtFJW9/C4Pn0dPTFG0StCBorMSNWpmBIuFnU7+Uh0DY49XZE02H2UJfZSulkfk3D9UG0nAQju7AkIMf3zXHfXBbdxrMSBsqXzwFyQqkvF87c/dDER2kePIH3sno8m1LELl/WoYRIGZLEPA2xRHGC0i0I8OZ3J7NZ7S9aZ/muI1ceiC
 Jbek1kjBNaRtSuyVqJfySkxKhW13dTV+jsywVPYLhM0tdJvBQt7olv68GHg0590GSX+McLyZ0Ay0x+0vfTwauxgZ8U1R28g6QY0pgzA==

On Mon, Jan 05, 2026 at 09:04:31AM -0500, Xin Long wrote:
> This commit adds quic.h to include/uapi/linux, providing the necessary
> definitions for the QUIC socket API. Exporting this header allows both
> user space applications and kernel subsystems to access QUIC-related
> control messages, socket options, and event/notification interfaces.
> 
> Since kernel_get/setsockopt() is no longer available to kernel consumers,
> a corresponding internal header, include/linux/quic.h, is added. This
> provides kernel subsystems with the necessary declarations to handle
> QUIC socket options directly.
> 
> Detailed descriptions of these structures are available in [1], and will
> be also provided when adding corresponding socket interfaces in the
> later patches.
> 
> [1] https://datatracker.ietf.org/doc/html/draft-lxin-quic-socket-apis
> 
> Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> Signed-off-by: Thomas Dreibholz <dreibh@simula.no>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
> v2:
>   - Fix a kernel API description warning, found by Jakub.
>   - Replace uintN_t with __uN, capitalize _UAPI_LINUX_QUIC_H, and
>     assign explicit values for QUIC_TRANSPORT_ERROR_ enum in UAPI
>     quic.h, suggested by David Howells.
> v4:
>   - Use MSG_QUIC_ prefix for MSG_* flags to avoid conflicts with other
>     protocols, such as MSG_NOTIFICATION in SCTP (reported by Thomas).
>   - Remove QUIC_CONG_ALG_CUBIC; only NEW RENO congestion control is
>     supported in this version.
> v5:
>   - Add include/linux/quic.h and include/uapi/linux/quic.h to the
>     QUIC PROTOCOL entry in MAINTAINERS.
> v6:
>   - Fix the copy/pasted the uAPI path for SCTP to the QUIC entry (noted
>     by Jakub).
> ---
>  MAINTAINERS               |   2 +
>  include/linux/quic.h      |  19 +++
>  include/uapi/linux/quic.h | 235 ++++++++++++++++++++++++++++++++++++++
>  net/quic/socket.c         |  38 ++++++
>  net/quic/socket.h         |   7 ++
>  5 files changed, 301 insertions(+)
>  create mode 100644 include/linux/quic.h
>  create mode 100644 include/uapi/linux/quic.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 46c28f087fd8..8d6187187978 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -21387,6 +21387,8 @@ M:	Xin Long <lucien.xin@gmail.com>
>  L:	quic@lists.linux.dev
>  S:	Maintained
>  W:	https://github.com/lxin/quic
> +F:	include/linux/quic.h
> +F:	include/uapi/linux/quic.h
>  F:	net/quic/
>  
>  RADEON and AMDGPU DRM DRIVERS
> diff --git a/include/linux/quic.h b/include/linux/quic.h
> new file mode 100644
> index 000000000000..d35ff40bb005
> --- /dev/null
> +++ b/include/linux/quic.h
> @@ -0,0 +1,19 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/* QUIC kernel implementation
> + * (C) Copyright Red Hat Corp. 2023
> + *
> + * This file is part of the QUIC kernel implementation
> + *
> + * Written or modified by:
> + *    Xin Long <lucien.xin@gmail.com>
> + */
> +
> +#ifndef _LINUX_QUIC_H
> +#define _LINUX_QUIC_H
> +
> +#include <uapi/linux/quic.h>
> +
> +int quic_kernel_setsockopt(struct sock *sk, int optname, void *optval, unsigned int optlen);
> +int quic_kernel_getsockopt(struct sock *sk, int optname, void *optval, unsigned int *optlen);
> +
> +#endif
> diff --git a/include/uapi/linux/quic.h b/include/uapi/linux/quic.h
> new file mode 100644
> index 000000000000..990b70c3afb0
> --- /dev/null
> +++ b/include/uapi/linux/quic.h
> @@ -0,0 +1,235 @@
> +/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
> +/* QUIC kernel implementation
> + * (C) Copyright Red Hat Corp. 2023
> + *
> + * This file is part of the QUIC kernel implementation
> + *
> + * Written or modified by:
> + *    Xin Long <lucien.xin@gmail.com>
> + */
> +
> +#ifndef _UAPI_LINUX_QUIC_H
> +#define _UAPI_LINUX_QUIC_H
> +
> +#include <linux/types.h>
> +#ifdef __KERNEL__
> +#include <linux/socket.h>
> +#else
> +#include <sys/socket.h>
> +#endif
> +
> +/* NOTE: Structure descriptions are specified in:
> + * https://datatracker.ietf.org/doc/html/draft-lxin-quic-socket-apis
> + */
> +
> +/* Send or Receive Options APIs */
> +enum quic_cmsg_type {
> +	QUIC_STREAM_INFO,
> +	QUIC_HANDSHAKE_INFO,
> +};
> +
> +#define QUIC_STREAM_TYPE_SERVER_MASK	0x01
> +#define QUIC_STREAM_TYPE_UNI_MASK	0x02
> +#define QUIC_STREAM_TYPE_MASK		0x03
> +
> +enum quic_msg_flags {
> +	/* flags for stream_flags */
> +	MSG_QUIC_STREAM_NEW		= MSG_SYN,
> +	MSG_QUIC_STREAM_FIN		= MSG_FIN,
> +	MSG_QUIC_STREAM_UNI		= MSG_CONFIRM,
> +	MSG_QUIC_STREAM_DONTWAIT	= MSG_WAITFORONE,
> +	MSG_QUIC_STREAM_SNDBLOCK	= MSG_ERRQUEUE,
> +
> +	/* extented flags for msg_flags */
> +	MSG_QUIC_DATAGRAM		= MSG_RST,
> +	MSG_QUIC_NOTIFICATION		= MSG_MORE,
> +};
> +
> +enum quic_crypto_level {
> +	QUIC_CRYPTO_APP,
> +	QUIC_CRYPTO_INITIAL,
> +	QUIC_CRYPTO_HANDSHAKE,
> +	QUIC_CRYPTO_EARLY,
> +	QUIC_CRYPTO_MAX,
> +};
> +
> +struct quic_handshake_info {
> +	__u8	crypto_level;
> +};
> +
> +struct quic_stream_info {
> +	__s64	stream_id;
> +	__u32	stream_flags;
> +};
> +
> +/* Socket Options APIs */
> +#define QUIC_SOCKOPT_EVENT				0
> +#define QUIC_SOCKOPT_STREAM_OPEN			1
> +#define QUIC_SOCKOPT_STREAM_RESET			2
> +#define QUIC_SOCKOPT_STREAM_STOP_SENDING		3
> +#define QUIC_SOCKOPT_CONNECTION_ID			4
> +#define QUIC_SOCKOPT_CONNECTION_CLOSE			5
> +#define QUIC_SOCKOPT_CONNECTION_MIGRATION		6
> +#define QUIC_SOCKOPT_KEY_UPDATE				7

This is a trivial point, but it would be better to align the indentation
of the line above.

Thank you,
Yohei Kojima

> +#define QUIC_SOCKOPT_TRANSPORT_PARAM			8
> +#define QUIC_SOCKOPT_CONFIG				9
> +#define QUIC_SOCKOPT_TOKEN				10
> +#define QUIC_SOCKOPT_ALPN				11
> +#define QUIC_SOCKOPT_SESSION_TICKET			12
> +#define QUIC_SOCKOPT_CRYPTO_SECRET			13
> +#define QUIC_SOCKOPT_TRANSPORT_PARAM_EXT		14
> +
> +#define QUIC_VERSION_V1			0x1
> +#define QUIC_VERSION_V2			0x6b3343cf
> +
> +struct quic_transport_param {
> +	__u8	remote;
> +	__u8	disable_active_migration;
> +	__u8	grease_quic_bit;
> +	__u8	stateless_reset;
> +	__u8	disable_1rtt_encryption;
> +	__u8	disable_compatible_version;
> +	__u8	active_connection_id_limit;
> +	__u8	ack_delay_exponent;
> +	__u16	max_datagram_frame_size;
> +	__u16	max_udp_payload_size;
> +	__u32	max_idle_timeout;
> +	__u32	max_ack_delay;
> +	__u16	max_streams_bidi;
> +	__u16	max_streams_uni;
> +	__u64	max_data;
> +	__u64	max_stream_data_bidi_local;
> +	__u64	max_stream_data_bidi_remote;
> +	__u64	max_stream_data_uni;
> +	__u64	reserved;
> +};
> +
> +struct quic_config {
> +	__u32	version;
> +	__u32	plpmtud_probe_interval;
> +	__u32	initial_smoothed_rtt;
> +	__u32	payload_cipher_type;
> +	__u8	congestion_control_algo;
> +	__u8	validate_peer_address;
> +	__u8	stream_data_nodelay;
> +	__u8	receive_session_ticket;
> +	__u8	certificate_request;
> +	__u8	reserved[3];
> +};
> +
> +struct quic_crypto_secret {
> +	__u8	send;  /* send or recv */
> +	__u8	level; /* crypto level */
> +	__u32	type; /* TLS_CIPHER_* */
> +#define QUIC_CRYPTO_SECRET_BUFFER_SIZE 48
> +	__u8	secret[QUIC_CRYPTO_SECRET_BUFFER_SIZE];
> +};
> +
> +enum quic_cong_algo {
> +	QUIC_CONG_ALG_RENO,
> +	QUIC_CONG_ALG_MAX,
> +};
> +
> +struct quic_errinfo {
> +	__s64	stream_id;
> +	__u32	errcode;
> +};
> +
> +struct quic_connection_id_info {
> +	__u8	dest;
> +	__u32	active;
> +	__u32	prior_to;
> +};
> +
> +struct quic_event_option {
> +	__u8	type;
> +	__u8	on;
> +};
> +
> +/* Event APIs */
> +enum quic_event_type {
> +	QUIC_EVENT_NONE,
> +	QUIC_EVENT_STREAM_UPDATE,
> +	QUIC_EVENT_STREAM_MAX_DATA,
> +	QUIC_EVENT_STREAM_MAX_STREAM,
> +	QUIC_EVENT_CONNECTION_ID,
> +	QUIC_EVENT_CONNECTION_CLOSE,
> +	QUIC_EVENT_CONNECTION_MIGRATION,
> +	QUIC_EVENT_KEY_UPDATE,
> +	QUIC_EVENT_NEW_TOKEN,
> +	QUIC_EVENT_NEW_SESSION_TICKET,
> +	QUIC_EVENT_MAX,
> +};
> +
> +enum {
> +	QUIC_STREAM_SEND_STATE_READY,
> +	QUIC_STREAM_SEND_STATE_SEND,
> +	QUIC_STREAM_SEND_STATE_SENT,
> +	QUIC_STREAM_SEND_STATE_RECVD,
> +	QUIC_STREAM_SEND_STATE_RESET_SENT,
> +	QUIC_STREAM_SEND_STATE_RESET_RECVD,
> +
> +	QUIC_STREAM_RECV_STATE_RECV,
> +	QUIC_STREAM_RECV_STATE_SIZE_KNOWN,
> +	QUIC_STREAM_RECV_STATE_RECVD,
> +	QUIC_STREAM_RECV_STATE_READ,
> +	QUIC_STREAM_RECV_STATE_RESET_RECVD,
> +	QUIC_STREAM_RECV_STATE_RESET_READ,
> +};
> +
> +struct quic_stream_update {
> +	__s64	id;
> +	__u8	state;
> +	__u32	errcode;
> +	__u64	finalsz;
> +};
> +
> +struct quic_stream_max_data {
> +	__s64	id;
> +	__u64	max_data;
> +};
> +
> +struct quic_connection_close {
> +	__u32	errcode;
> +	__u8	frame;
> +	__u8	phrase[];
> +};
> +
> +union quic_event {
> +	struct quic_stream_update	update;
> +	struct quic_stream_max_data	max_data;
> +	struct quic_connection_close	close;
> +	struct quic_connection_id_info	info;
> +	__u64	max_stream;
> +	__u8	local_migration;
> +	__u8	key_update_phase;
> +};
> +
> +enum {
> +	QUIC_TRANSPORT_ERROR_NONE			= 0x00,
> +	QUIC_TRANSPORT_ERROR_INTERNAL			= 0x01,
> +	QUIC_TRANSPORT_ERROR_CONNECTION_REFUSED		= 0x02,
> +	QUIC_TRANSPORT_ERROR_FLOW_CONTROL		= 0x03,
> +	QUIC_TRANSPORT_ERROR_STREAM_LIMIT		= 0x04,
> +	QUIC_TRANSPORT_ERROR_STREAM_STATE		= 0x05,
> +	QUIC_TRANSPORT_ERROR_FINAL_SIZE			= 0x06,
> +	QUIC_TRANSPORT_ERROR_FRAME_ENCODING		= 0x07,
> +	QUIC_TRANSPORT_ERROR_TRANSPORT_PARAM		= 0x08,
> +	QUIC_TRANSPORT_ERROR_CONNECTION_ID_LIMIT	= 0x09,
> +	QUIC_TRANSPORT_ERROR_PROTOCOL_VIOLATION		= 0x0a,
> +	QUIC_TRANSPORT_ERROR_INVALID_TOKEN		= 0x0b,
> +	QUIC_TRANSPORT_ERROR_APPLICATION		= 0x0c,
> +	QUIC_TRANSPORT_ERROR_CRYPTO_BUF_EXCEEDED	= 0x0d,
> +	QUIC_TRANSPORT_ERROR_KEY_UPDATE			= 0x0e,
> +	QUIC_TRANSPORT_ERROR_AEAD_LIMIT_REACHED		= 0x0f,
> +	QUIC_TRANSPORT_ERROR_NO_VIABLE_PATH		= 0x10,
> +
> +	/* The cryptographic handshake failed. A range of 256 values is reserved
> +	 * for carrying error codes specific to the cryptographic handshake that
> +	 * is used. Codes for errors occurring when TLS is used for the
> +	 * cryptographic handshake are described in Section 4.8 of [QUIC-TLS].
> +	 */
> +	QUIC_TRANSPORT_ERROR_CRYPTO			= 0x0100,
> +};
> +
> +#endif /* _UAPI_LINUX_QUIC_H */
> diff --git a/net/quic/socket.c b/net/quic/socket.c
> index a0eedf59545a..a0ebc6b56879 100644
> --- a/net/quic/socket.c
> +++ b/net/quic/socket.c
> @@ -121,6 +121,25 @@ static int quic_setsockopt(struct sock *sk, int level, int optname,
>  	return quic_do_setsockopt(sk, optname, optval, optlen);
>  }
>  
> +/**
> + * quic_kernel_setsockopt - set a QUIC socket option from within the kernel
> + * @sk: socket to configure
> + * @optname: option name (QUIC-level)
> + * @optval: pointer to the option value
> + * @optlen: size of the option value
> + *
> + * Sets a QUIC socket option on a kernel socket without involving user space.
> + *
> + * Return:
> + * - On success, 0 is returned.
> + * - On error, a negative error value is returned.
> + */
> +int quic_kernel_setsockopt(struct sock *sk, int optname, void *optval, unsigned int optlen)
> +{
> +	return quic_do_setsockopt(sk, optname, KERNEL_SOCKPTR(optval), optlen);
> +}
> +EXPORT_SYMBOL_GPL(quic_kernel_setsockopt);
> +
>  static int quic_do_getsockopt(struct sock *sk, int optname, sockptr_t optval, sockptr_t optlen)
>  {
>  	return -EOPNOTSUPP;
> @@ -135,6 +154,25 @@ static int quic_getsockopt(struct sock *sk, int level, int optname,
>  	return quic_do_getsockopt(sk, optname, USER_SOCKPTR(optval), USER_SOCKPTR(optlen));
>  }
>  
> +/**
> + * quic_kernel_getsockopt - get a QUIC socket option from within the kernel
> + * @sk: socket to query
> + * @optname: option name (QUIC-level)
> + * @optval: pointer to the buffer to receive the option value
> + * @optlen: pointer to the size of the buffer; updated to actual length on return
> + *
> + * Gets a QUIC socket option from a kernel socket, bypassing user space.
> + *
> + * Return:
> + * - On success, 0 is returned.
> + * - On error, a negative error value is returned.
> + */
> +int quic_kernel_getsockopt(struct sock *sk, int optname, void *optval, unsigned int *optlen)
> +{
> +	return quic_do_getsockopt(sk, optname, KERNEL_SOCKPTR(optval), KERNEL_SOCKPTR(optlen));
> +}
> +EXPORT_SYMBOL_GPL(quic_kernel_getsockopt);
> +
>  static void quic_release_cb(struct sock *sk)
>  {
>  }
> diff --git a/net/quic/socket.h b/net/quic/socket.h
> index 0aa642e3b0ae..7ee190af4454 100644
> --- a/net/quic/socket.h
> +++ b/net/quic/socket.h
> @@ -9,6 +9,7 @@
>   */
>  
>  #include <net/udp_tunnel.h>
> +#include <linux/quic.h>
>  
>  #include "common.h"
>  #include "family.h"
> @@ -29,6 +30,7 @@ struct quic_sock {
>  	struct inet_sock		inet;
>  	struct list_head		reqs;
>  
> +	struct quic_config		config;
>  	struct quic_data		ticket;
>  	struct quic_data		token;
>  	struct quic_data		alpn;
> @@ -49,6 +51,11 @@ static inline struct list_head *quic_reqs(const struct sock *sk)
>  	return &quic_sk(sk)->reqs;
>  }
>  
> +static inline struct quic_config *quic_config(const struct sock *sk)
> +{
> +	return &quic_sk(sk)->config;
> +}
> +
>  static inline struct quic_data *quic_token(const struct sock *sk)
>  {
>  	return &quic_sk(sk)->token;
> -- 
> 2.47.1
> 
