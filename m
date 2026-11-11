Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.146
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794413546;
	b=aMtOFJzQsA31XoGvn5PD700JWysrG2IjNMirNADdV6BubhelMtyX/8jLzmNBOcCzDGVx
	 ldLgxsm3MnG4UXzY8DUX/N44hwOH2iwQeB8ZrKag+M86cFzDKq7HIfeWBsx9eZJ/6ktJV
	 R4V11m8f5CD56dfVw5LKX/ZiY1+ulyEKgoWZFv1wLfEiXMeeGC8bmedvV7cNAUuK25aq6
	 Wzr6wrd6RVoQ8fXhV0uj0Sn7UCErOr4WcxSeWVEbd7WHeFbAiTB87fvCxm+Qfsf7gkbr9
	 HBsbv4Vb7eS1Z5kntiV/Ebh0vyWLxJ+zJaJ1RuOiOcmV0GedTnHfIuEoOjBHROCmdxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794413546;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=4LWIfz0LXniS79CwSXUL1sTo15BzWIHPZTTjWShoiso=;
	b=IvqqqNIwbzF4m16Qer/AgWw+nh/1b9e0mnMSYJ4fAkVJMLR2/l8XDRayGyA7NiO5SY98
	 tQ8d9+lqJXNZpmWOSHmtfDTif5m+V1mC1M74EDddUc1Mc1SE8J2uRYx9i5n0szk6pPnp6
	 +kuh00AOGB9qEZ/il9SQvfPyL8GotsEpaClKE8d0hcvsDGJGz7szLj4ByEF0phKXp4/2K
	 pU1SxYTxf7YemB4P/D/EJ/XlJI++IVxs9lDwKlAV0iyduZUll7kRZo8DP9RvwHJqhQ70m
	 xgleqQpUH6qS5ExfY7AoAYWG7yLG/0BrNuOKjrxzjlF4sk944Th83ypOJ/NGVbb/fcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=0hkJRnZ9;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b="w/NgFr8g";
	arc=none smtp.remote-ip=103.168.172.146
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4439E606A32A
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 16:12:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4439E606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=0hkJRnZ9;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=w/NgFr8g
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 75429EC05BB
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 11:12:25 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 11 Nov 2026 11:12:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1794413545; x=
	1794499945; bh=4LWIfz0LXniS79CwSXUL1sTo15BzWIHPZTTjWShoiso=; b=0
	hkJRnZ9DToq3a1vzW9IdMIRvvetyzWyVmqRC7GIuxQg7Y9z0cAkszPvH/n+csGEr
	pE3R7fBpzZDE5dGeJ2UIZ0xEP1YiwZjM8KcuwA84O7EhhwKuRuOlYiUYVDsZSNHp
	D7mdmgdO9TQ9evl1RkybdPRI1aEG9XiqoXLN4bHLtv5Z/RE6siJmmRfc8n9GIZwO
	bkMK/V3DLKyGuj5dyjAXSXtd8+fTfQfgYMVW9w8996MluFJUeXXkoDKENmMYvG4P
	+z7ybiCBg/2BPzV6Y/dM7hYupnxtlIbGGJd1RRi54gtTL9gvHpv+ELt1XizHESXV
	MsV/aB8yd6BMs0v8x5Jnw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794413545; x=1794499945; bh=4
	LWIfz0LXniS79CwSXUL1sTo15BzWIHPZTTjWShoiso=; b=w/NgFr8gGNS5GQ4rO
	XXlIGn9PvPizdUPfi7WFXo9FeUVvaw/tjLiJkg6dAL3Ezcqa56URbHD5cLyU/Gwv
	DioXaNh/8yG7Q/RxCnrg+A8kNCIS36ViwIpdjT4+6hgs8RUkrUWbeAneopnSoUfB
	X3+I1Y3TS4JJnxG0+wsfan5flmOKfT3Vw6DCAYGXG3sRif8ORqJks99FcV7qEeXq
	UB65JlgUA69ZA1gIW+ZfGe1+7xvDO9ae25sBkCdXHoagfmLISSNCXuq+H05stgNd
	QP4mKFNm/fJES0ZYIVWwXbR7Zuh1cEQzADmnGlzR2sqSiSnnkhieJvH6Nit3jcWu
	TkStw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794413545; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:Wz40lfFaKCCQHO2j/qsBzhgiK5NZ+WkSVrWUPpWn3bc6TS5
	ypBMaIU7MrlcxHeqSE9j61NmJxfHw1sW2AGZbF29il4T25S3K8ClLvWB8n1s7vyo
	4Q0vaib9bvotMip/q8NhE+oROG9+UM5FGJtQRTDN6mNY8FZmA2RdzDZGWLdpU29l
	a0N9Zi6JcNnPI+dm6SAVQN9jW+tGrTAnP3bAtWwumRgyFl7gF/EY/cRHVM4FaKeS
	jj0/nQpVFA14gINKNizqJ+mAO5CRJrVnG9ld5LRTV39hTiOHm5hsj++BXCsw8ElZ
	iJDCFzZlJN1XnQMfTQjQy4XDyOTIaP+dXQ1ZWBQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:jZAot0+yAGnEvPYGis+eFBQ5dZDgM7hmab2s5LnTOIk=:igzaP6AJEXP1a40IWvxYxVxWGW0gJZkrWuBBgHF48YA=;
X-ME-Sender: <xms:6ZP0agpH1BdyI_c3Y_Hpbp_Cfgp73L4vXnde9uNa0cTFCebxgBRp8w>
    <xme:6ZP0asqyb9-BmKz2tvFfWOBEQWXuovzcwf3-t2kYxPuZvS9K77g7yUO5LOHbHb-rb
    AnSKBqML_AZJLT49zuRb4y2xnSl6V5Ty5CP0TYIp6RPIS3Z-AR5_Vhq>
X-ME-Received: <xmr:6ZP0agAFKQ8QTP6orNapbONeLqycyw4jeOWsLcZKG5TkSfPyh7BwXfWoPIkVZg2C>
X-ME-Proxy-Cause: dmFkZTEEdbrRFWR0eBKe5v/KfypfLLl/fRZb14YgUijhe01X8oiOT4nHPo8rMe7bc2/Ckq
    sCGCuwV/iK89RoqtMD+/hj2wVUekqHuNWusm9yUS3FP3mh/Dzsu8iO5RWo+jDsgEDYG2Vu
    Vhc/k1nrAqISnXm4S67v7t0D+Ix1sNE+1y7OelDhqwkIFG2E0xP0i8OsTKDjqKVRgAB4Yk
    87DTR7uoK12BdAKefs0htoSFphplUjmmGgDczfWsq93xlzc7hjqcmmoMKIVb7qobZJnIKx
    k+NOZIiCtqmqRGi83enLRpJm/s183W5wQSVSbrS1PSqCA0GAxxm9f3cCcfZvoaD84wX9aM
    7dTBnOMn4gliL3OvwY91vsDIAraMp9M0p9V/do8RtotKsZIqVylj0PbcLwinbRcHtwt4Yf
    4oOCcoR8Lxje3uOaj847if67Pck8pMh6sZ4ZCaNJQy7Dseqmh3D8rxBBKgpOfAedyZFCSo
    rND4TbnETICVumobqxf0CDQX7OEC13B2emPCuREnnstGq6Tl1IbQczClPaTNaXayvZgNJL
    1JAf/+xU6MVkDKMPYVlSqfJYXhkRfKh22dbMXvAjyfokbkLWeR3lXv7HqQqKAct7dlK4t8
    USIMFkF1J+5bq5samcn3/p+TObtQ5rsS+znd+RE+K1zuicV48KDEZz4nwq0Q
X-ME-Proxy: <xmx:6ZP0aqsxZ61oGGaBr7FLgC6wH1_CSMmGoToVqXikTk9zU8rGTOyHLA>
    <xmx:6ZP0avKJrijaLqAIdU9YE3cauYNUnOhV3bJF8-Xt5hpHt6SiGxz2OQ>
    <xmx:6ZP0ahau0IsBkDlihU0DmIxIRAiK9lTvovpS6QQ8XeLbBE2a__wKwg>
    <xmx:6ZP0ahAn2IsV3QuLL3vsszQsAcj5nEdC_oT7rt6ZQGY_Kz_aodklCw>
    <xmx:6ZP0ajyJZSg3f1kF6udaxuo-wrN47t6EIHa_Zyy9YCYyg2gOb2ACULCN>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Nov 2026 11:12:23 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: jan.koester@tuxist.de
Cc: linkinjeon@kernel.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	brauner@kernel.org,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: Re: [RFC PATCH 6/6] Documentation: uid_r: describe ksmbd's SID mapping
Date: Wed, 11 Nov 2026 10:12:17 -0600
Message-ID: <20261111161217.4128662-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ae30e40693d0f8b9f21a27e0@groupi3>
References: <ae30e40693d0f8b9f21a27e0@groupi3>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jan,

On Tue, Nov 10, 2026 at 09:02:57AM +0000, Jan Koester wrote:
> +	rather than ignored. A session's user matches ACL entries naming its
> +	own or its groups' SIDs, mapped or not.

As I read 4/6, the token is built only at login. Would a mapping that
user space cannot give then stay missing for the whole session, so the
session does not match ACL entries naming that mapped SID until a new
login gets the mapping? If so, could the text say that? For a deny
entry the session could then get access through another allow entry,
though that part would need a fix in 4/6 rather than in the text.

Thanks,
Ian
