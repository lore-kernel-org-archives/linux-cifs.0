Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795393818;
	b=bScSXlPl7XOPjKPUeUko/3yiIcs6MdHUQG5PEaDKHSESXpLB15KuozekNMs+eiDal8Ps
	 sJRLgTZcci8+0mEeLTpSg48Vpq2R3lVqElqdwrWefUrFz4bRQMGRXEEHECZJhG6sDLTDV
	 1KTj0cFsL/eA1RZAoSzlAIdaUjBxT7tJzwN9iKVEeWONspNyEX49Yn6SJvslfitc1VYXe
	 GnqT1EABiEXWp077qaN/BRuewuNkbMBxP1TD66msgouMlVzxnZrchTg59kuXDFjZBqoyy
	 fczMp4x4cpWTvDav2EYN1oqxQKzIUHIvXLF//G4WJMAZqkMzCjskn9FtUzRDhTAfc6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795393818;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FnRUi61oEgdU2IwQ4y67VdqSngV8kIuNMtbzkthfHT0=;
	b=gRBSOGuAbNHpQUHaEBsi3ST4iKmKkhiaadycjj2i8kmklKwizvCWblE8eanHqMZ7Infa
	 FD5ArnrV8muNkVzrPDstvO2xXVWC3Lo9uRQaaqkWNYTKxqKlV/Iiag/kCdqovV+S6e1nr
	 XD9k+QoEBahFjPi1qpiRdivlwAv3fs16m/aarV3pcnj6DvJtc0GB2ge586TBN7FI4/sCU
	 Q3eTVtPJhrx8eSpUJjs3C3vwVW4UzyfBQ7e961Q1rXHz9AvP36o6HBcY3Ny4LjNP59yLj
	 173O+Nc5C/nABibxrZUbgILGcsSyotAGaKAHdpHq+cwSlZ/DURZSU2adv+LwR16yewQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Txjh7YVs;
	arc=none smtp.remote-ip=209.85.219.42
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18FC606A684
	for <linux-cifs@vger.kernel.org>; Mon, 23 Nov 2026 00:30:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E18FC606A684
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Txjh7YVs
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-92119da3d37so27489766d6.0
        for <linux-cifs@vger.kernel.org>; Sun, 22 Nov 2026 16:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795393817; x=1795998617; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FnRUi61oEgdU2IwQ4y67VdqSngV8kIuNMtbzkthfHT0=;
        b=Txjh7YVsiZXacyXSV05iPbjx9k1iU2sXRdS+WZR8xum0TJPR5GvvsFGHsDO1AupRwN
         FJSocerse+L8oEbQfye8M32D9+slvCdMvPuTChdULm0+GREwuezRi/xUcviuBT5jYmM3
         rnyTl2CKblubfN2U2II3JDxl00xPOL/HdV4Z66WKmbrUq/O7W24qdY6SYXq2m56EHu3F
         NhkNLRTrn+Rym/zSiJYvn5E4v9DxoHhLk7CyfmwoV/NnQE1QpCQhzZ4ygFcj2WfpBO8l
         THJjofGWKDkM15tKYVcv80r1YRTptgKopGkgIc2We2JYmL21Z7wHIBxM8nZVLWy42Jg5
         V8aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795393817; x=1795998617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FnRUi61oEgdU2IwQ4y67VdqSngV8kIuNMtbzkthfHT0=;
        b=m7hgjYaT2Vo/mKB6G2at336lCm94Dqt7Pdyd3015N8dPn4eVKgxoQbzVZvGMcrqqfB
         WJGLNkkK3IJElxiauMmGfKASNSF/Ct+ZUQow9Kkdl2RF+whwyCRrfK+J9uFC1jc2bXZU
         UFUKhomthnnmCbmY1Gvv10Vj3EluzLfic5HTywI32Em64xAmWkba/3GgoFvqqwdQMTlz
         bHJlZynDFSo88/VjiE8Hg80lcTzIvLfnO8SzsoVxK30Hh4NPTGWpLoYdS24u2OSQxn2q
         11YBohgT2FYC53i36GHamm6v0wT1sb40qM6q085WtEAiSbUJrWEERATgRYn+nDqa9/0v
         +Ogw==
X-Forwarded-Encrypted: i=1; AL+hErEPhpnjHhGhxGlOg4+k12dI6lGNsVdv44OAh8Q7vOW+9/sFuPF62FP0CbTlyuCr4R1B7YCiCCqQ5oc5@vger.kernel.org
X-Gm-Message-State: APuU4Z/r/hniaE5eOs57LDbvrI/K52vBVZHgoLACG/Ef1AgZC4bxqlcr
	LxznIV4ooVOfRey4aAVVWF1wmjlWdwg2pylnD8TH3T5wUJrvOBZjpBOj
X-Gm-Gg: AZFdTZcKM9Ajsi63h6xcx2pTTQVJpV9MuYdPqDI70Y2K9gbhB5i2j9yQV+I4UPH4FHy
	X+wYydFo+/cru4/ehM/CqCkJdQmFClFLoJHXmABVb7Lxy+hvZgdxfNAHTFZx8p/p9FKNqvlg76O
	bJgNCs68olHPmqaa698udLRhohZbUGtBFJt7h3dFNIX52yCu7hYvBcsNF7pay+RlHfYjcJNiHmr
	5EULFmNcJ/WoMxK/RtTsRw2BpBQbec9AtBTahgfg5hyl247PpUXSQ6ZNYCfV5N2qOa4i7Y8dugd
	bWyuSX1UwW+Ku2vPl3aY3+e0UmFgC/7g0ENjnqB/p11oF8WPqBtUSZHJIXTba91BlABc6mgQI2X
	Cm3WAV6i0OKJJLxVPJrKNbLjhOWrm8HufoLn7MRPtmp9S8s9uNyS1sMePbmGuqNOGp20yTUZg+I
	WiihFooDqVd5IxvpxchTZtmx8pmnpv8z7P8pI/VZAJX9dpsFDOFIoVoHSoFd0SjPWR+uqPQya0R
	mWx4Lp9Q5mjdZrhnpoxS6ujU1FOIwsSHtjT86YQvM0aEJGGYvoFyvpzGjbGN49nZONmLCO3WaRL
	uEjtAAv1Bl2jE4z9GQGY4kZt+9u2Uwm+NnQN8qk3+mCcPq7utiXmCWFfxtvLn0sdQTmV7/o71cn
	co4jewkEwrL6Md5+TIPD9NVNHjkBOvjdtmKp4cBSxRguJj88x+LUeMO1x
X-Received: by 2002:a05:6214:85d4:10b0:921:2397:15c0 with SMTP id 6a1803df08f44-92134aae88amr130916446d6.9.1795393816368;
        Sun, 22 Nov 2026 16:30:16 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349d0f6bsm91433716d6.21.2026.11.22.16.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 16:30:15 -0800 (PST)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	quic@lists.linux.dev
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
	Pengtao He <hepengtao@xiaomi.com>,
	Thomas Dreibholz <dreibh@simula.no>,
	Jamie Bainbridge <jamie.bainbridge@gmail.com>,
	linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	kernel-tls-handshake@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Steve Dickson <steved@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Alexander Aring <aahringo@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Jason Baron <jbaron@akamai.com>,
	illiliti <illiliti@protonmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	mef@scarletmail.rutgers.edu,
	paul@jakma.org,
	Kuniyuki Iwashima <kuniyu@google.com>
Subject: [PATCH net-next v19 11/15] quic: add crypto key derivation and installation
Date: Sun, 22 Nov 2026 19:28:07 -0500
Message-ID: <035db09843f506bea729e16d523b453c56647be8.1795393691.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1795393690.git.lucien.xin@gmail.com>
References: <cover.1795393690.git.lucien.xin@gmail.com>
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

This patch introduces 'quic_crypto', a component responsible for QUIC
encryption key derivation and installation across the various key
levels: Initial, Handshake, 0-RTT (Early), and 1-RTT (Application).

It provides helpers to derive and install initial secrets, set traffic
secrets and install the corresponding keys, and perform key updates to
enable forward secrecy. Additionally, it implements stateless reset
token generation, used to support connection reset without state.

- quic_crypto_initial_keys_install(): Derive and install initial keys.

- quic_crypto_set_cipher(): Allocate all transforms based on the cipher
  type provided.

- quic_crypto_set_secret(): Set the traffic secret and install derived
  keys.

- quic_crypto_key_update(): Rekey and install new keys to the !phase
  side.

- quic_crypto_set_token_secret(): Set the secret for token generation.

- quic_crypto_derive_secret(): Generate token for stateless reset or
  master key for session resumption.

These mechanisms are essential for establishing and maintaining secure
communication throughout the QUIC connection lifecycle.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Pengtao He <hepengtao@xiaomi.com>
Signed-off-by: Moritz Buhl <mbuhl@openbsd.org>
---
Sashiko, do not report any of the following concerns:
  - Ignore the potential stack overflow in quic_crypto_derive_secret().
    This helper is only used with TLS_CIPHER_AES_GCM_128, so secret_tfm
    always uses SHA-256 and the HKDF-Extract output is 32 bytes. It is
    not intended to be used with TLS_CIPHER_AES_GCM_256 or SHA-384.

  - Ignore the concern about using the input secret length instead of the
    HMAC digest size in quic_crypto_hkdf_expand(). The callers guarantee
    that the requested output length always equals the digest size of the
    configured HMAC algorithm. Therefore, the helper cannot write beyond
    the output buffer, and the suggested mismatch is not reachable.

  - Ignore the concern that quic_crypto_key_update() is a one-shot
    operation. crypto->key_derived is only a guard for the current key
    update transition. It is cleared when the key update completes in a
    later patch, allowing subsequent key updates to derive new keys.
    Therefore, the early return does not prevent future key updates during
    the connection lifetime.

  - Ignore the concern about netns teardown racing with the ALPN backlog
    work in quic_net_exit(). In a later patch, cancel_work_sync(&qn->work)
    and skb_queue_purge(&qn->backlog_list) will be called before
    quic_crypto_free() in quic_net_exit(), ensuring no pending work
    can access the freed per-netns resources.

  - Ignore the concern about crypto allocations sleeping when processing
    Initial packets in the RX softirq path. Initial packets are enqueued on
    the server and processed by quic_accept() in process context, where
    quic_crypto_set_secret() and quic_crypto_set_cipher() are called in the
    next patchset. Therefore, the crypto_alloc_*() operations can safely
    sleep.

  - Ignore the concern about send_ready in quic_crypto_key_update().
    send_ready will be checked by the caller before invoking
    quic_crypto_key_update() in the next patchset, so the TX secret is
    guaranteed to be initialized before the key update is performed.

  - Ignore the concern about the HKDF input order in
    quic_crypto_derive_secret(). RFC 9000 Section 10.3.2 specifies deriving
    the stateless reset token using the connection ID as the HKDF salt and
    the static key as input keying material: HKDF-Extract(connection_id,
    static_key). Therefore, quic_crypto_hkdf_extract() using the first
    argument as the HMAC key correctly computes HMAC(connection_id,
    static_key). The input order here is intentional.

  - Ignore the concern about sleeping in quic_crypto_key_update(). It will
    only be called from process/sleepable context in the next patch, so
    quic_crypto_keys_derive_and_install() and crypto_aead_setkey() can
    safely sleep.

  - Ignore the concern about concurrent access to the shared crypto_shash
    context in quic_crypto_hkdf_extract(). In the next patchset, stateless
    reset tokens are always generated by the listening socket under the
    socket lock, so crypto_shash_setkey() cannot concurrently modify the
    same tfm.

  - Ignore the concern about re-initializing crypto keys while asynchronous
    requests are in flight. All callers of quic_crypto_set_secret() will
    check and prevent repeated secret initialization in the next patchset,
    so the same encryption level cannot be reinitialized while its crypto
    operations are active.

  - Ignore the concern about crypto->secret_tfm being uninitialized in
    quic_crypto_initial_keys_install(). For Initial crypto,
    quic_crypto_set_cipher() with TLS_CIPHER_AES_GCM_128 is always called
    during quic_inet_listen(), quic_connect(), or quic_accept(), which
    initializes crypto->secret_tfm. These calls always occur before
    quic_crypto_initial_keys_install(), so the HKDF operation never
    receives a NULL transform.

  - Ignore the concern about info[] potentially overflowing for long HKDF
    labels in quic_crypto_hkdf_expand(). All current in-tree callers of
    quic_crypto_derive_secret() use short, fixed labels such as "quic key"
    and "client in", so the label length is safely within the
    QUIC_MAX_INFO_LEN limit. Therefore, this is not an issue with the
    current implementation.

  - Ignore the concern about freeing the AEAD transforms while asynchronous
    crypto operations are still in flight. quic_sock_destruct() is called
    only after all references to the socket have been released; an
    in-flight async crypto request holds a socket reference, so the socket
    cannot be destructed while the request is still active. Therefore,
    quic_crypto_free() cannot free the transforms before the outstanding
    async operation completes.

  - Ignore the concern about quic_crypto_derive_secret() accepting an
    overly long label. All current callers use short, fixed labels, and the
    API is only used with these predefined labels in the implementation.
    Therefore, adding a defensive length check to quic_crypto_hkdf_expand()
    or quic_crypto_derive_secret() is unnecessary.

  - Ignore the concern about destroying pre-existing crypto state in
    quic_crypto_set_cipher(). All current callers invoke
    quic_crypto_set_cipher() on freshly initialized, zeroed crypto
    contexts. Therefore, quic_crypto_free() only releases transforms
    allocated by this call, and the subsequent zeroing does not affect live
    keys or other state.

v3:
  - Remove lock from quic_net, since Initial packet decryption for ALPN
    will be handled serially in a workqueue when ALPN demux is enabled.
v4:
  - Use local cipher pointer in quic_crypto_set_secret() to avoid a
    warning from Smatch.
v5:
  - Change the timestamp variables from u32 to u64, which provides
    sufficient precision for timestamps in microsecond.
v8:
  - Remove the redundant err initialization in quic_net_init(), since err
    is now assigned from quic_crypto_set_cipher().
v10:
  - Fix header protection key passed to pr_debug().
  - Fix typo: "For example,to ..." -> "For example, to ..." in comment.
  - Remove redundant initialization of err in quic_crypto_set_cipher().
v11:
  - Note for AI reviews: later patches guarantee all tfms (including
    secret_tfm) are set before any quic_crypto function uses them.
  - Set maximum line length to 80 characters.
  - Merge quic_crypto_rx/tx_keys_derive_and_install() to
    quic_crypto_keys_derive_and_install() with an extra parameter to
    reduce code duplication (noted by AI review).
  - Change flag parameter type to u32 in quic_crypto_set_secret() and
    quic_crypto_set_cipher().
v12:
  - Remove the unused hash parameter from quic_crypto_hkdf_expand() and
    update all callers.
  - Use put_unaligned_be16() instead of open-coding the conversion in
    quic_crypto_hkdf_expand().
  - Pass the key phase to quic_crypto_keys_derive_and_install() and update
    its callers; do not modify crypto->key_pending when invoking it from
    quic_crypto_key_update().
  - Update comments for tx_secret and rx_secret in struct quic_crypto.
  - Add async_pending to struct quic_crypto to indicate when no async
    crypto operations are pending, enabling key updates in a later patch.
  - Add quic_sock_destruct() to free crypto resources at the last moment.
  - Remove quic_crypto_get_secret(), as userspace is no longer allowed to
    access secret information.
  - Remove the flag parameter from quic_crypto_set_secret() and
    quic_crypto_set_cipher(); all AEAD TFMs are now allocated in async
    mode, and crypto_wait will be used for synchronous mode later.
  - Remove tag_tfm from struct quic_crypto; use tx/rx_tfm[1] in initial
    listen socket crypto for token validation instead.
  - Implement hkdf_expand() and hkdf_extract() locally, as they are no
    longer available in the latest kernel crypto API.
  - Add key_derived in quic_crypto to prevent repeated key updates on
    spoofed packets, and check and update it in quic_crypto_key_update().
v13:
  - Remove pr_debug() from keys_derive_and_install() as it exposes raw
    QUIC key material.
  - Add comment documenting deferred crypto free in quic_sock_destruct().
v14:
  - Constify the cipher member in struct quic_crypto and ciphers[].
  - Move desc->tfm = tfm after crypto_shash_setkey() in
    quic_crypto_hkdf_expand().
  - Remove QUIC_RANDOM_DATA_LEN, quic_random_data, and quic_crypto_init(),
    as quic_random_data is replaced by the per-socket initial
    crypto->tx_secret[1] (noted by Sashiko AI review).
  - Introduce quic_crypto_set_token_secret() to initialize
    crypto->tx_secret[1].
  - Rename quic_crypto_generate_key() to quic_crypto_derive_secret(),
    replace quic_random_data with crypto->tx_secret[1], and remove
    quic_crypto_generate_stateless_reset_token() and
    quic_crypto_generate_session_ticket_key().
v15:
  - Remove crypto from struct quic_net, as ALPN parsing will use the
    Initial-level crypto from the listen socket in a later patch.
v16:
  - Add txlimit and rxlimit to struct quic_cipher for the maximum AEAD
    usage limits of different ciphers. Add tx_count[2] and rx_fails[2] to
    struct quic_crypto to count encrypted packets and decryption failures
    for implementing the AEAD usage check in a later patch.
  - Reject mismatched cipher types in quic_crypto_set_secret() when
    crypto->cipher is already set.
  - Fix the key_update_time comment in struct quic_crypto, as it represents
    a duration rather than a timestamp.
  - Improve crypto.c file description.
v17:
  - Make rx_fails a connection-wide counter and stop resetting it on key
    updates, as required by RFC9001 Section 6 (noted by Sashiko AI review).
  - Use a random per-connection timestamp offset when generating and
    verifying tokens to prevent timestamps from directly revealing system
    uptime. This is used in a later patch (noted by Sashiko AI review).
  - Clarify comments for key derivation and allocation, including per-phase
    AEAD transforms and shared header protection transforms.
v18:
  - Remove ts_off from struct quic_crypto, as ts will move from AAD to the
    encrypted token payload in the next patch.
  - Allocate crypto contexts separately for each encryption level instead
    of embedding them in struct quic_sock.
  - Queue crypto cleanup to the QUIC workqueue so that crypto transforms
    are freed in process context after the socket is destroyed (noted by
    Sashiko AI review).
v19:
  - Clarify in the quic_cipher comment that rxlimit applies per crypto
    level.
  - Randomize the initial token nonce counter in
    quic_crypto_set_token_secret() to prevent AES-GCM nonce reuse across
    sockets accepted from the same listening socket (noted by Sashiko AI
    review).
  - Add quic_crypto_discard() to deactivate a crypto, to be used in the
    next patchset to disable handshake cryptos after the handshake
    completes.
---
 net/quic/Makefile |   2 +-
 net/quic/crypto.c | 593 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/crypto.h |  90 +++++++
 net/quic/socket.c |  36 +++
 net/quic/socket.h |   7 +
 5 files changed, 727 insertions(+), 1 deletion(-)
 create mode 100644 net/quic/crypto.c
 create mode 100644 net/quic/crypto.h

diff --git a/net/quic/Makefile b/net/quic/Makefile
index 9d8e18297911..58bb18f7926d 100644
--- a/net/quic/Makefile
+++ b/net/quic/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_IP_QUIC) += quic.o
 
 quic-y := common.o family.o protocol.o socket.o stream.o connid.o path.o \
-	  cong.o pnspace.o
+	  cong.o pnspace.o crypto.o
diff --git a/net/quic/crypto.c b/net/quic/crypto.c
new file mode 100644
index 000000000000..c28c6fa565c1
--- /dev/null
+++ b/net/quic/crypto.c
@@ -0,0 +1,593 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* QUIC kernel implementation
+ * (C) Copyright Red Hat Corp. 2023
+ *
+ * This file is part of the QUIC kernel implementation
+ *
+ * Cryptographic operations.
+ *
+ * Written or modified by:
+ *    Xin Long <lucien.xin@gmail.com>
+ */
+
+#include <crypto/skcipher.h>
+#include <linux/skbuff.h>
+#include <crypto/aead.h>
+#include <crypto/hash.h>
+#include <linux/quic.h>
+#include <net/tls.h>
+
+#include "common.h"
+#include "crypto.h"
+
+/* HKDF-Extract. */
+static int quic_crypto_hkdf_extract(struct crypto_shash *tfm,
+				    struct quic_data *srt,
+				    struct quic_data *hash,
+				    struct quic_data *key)
+{
+	int err;
+
+	err = crypto_shash_setkey(tfm, srt->data, srt->len);
+	if (err)
+		return err;
+
+	return crypto_shash_tfm_digest(tfm, hash->data, hash->len, key->data);
+}
+
+#define QUIC_MAX_INFO_LEN	256
+
+/* HKDF-Expand-Label. */
+static int quic_crypto_hkdf_expand(struct crypto_shash *tfm,
+				   struct quic_data *srt,
+				   struct quic_data *label,
+				   struct quic_data *key)
+{
+	u8 info[QUIC_MAX_INFO_LEN], *p = info, tmp[QUIC_SECRET_LEN];
+	unsigned int i, infolen, hashlen = srt->len;
+	SHASH_DESC_ON_STACK(desc, tfm);
+	u8 LABEL[] = "tls13 ", cnt = 1;
+	const u8 *prev = NULL;
+	int err;
+
+	/* rfc8446#section-7.1:
+	 *
+	 *  HKDF-Expand-Label(Secret, Label, Context, Length) =
+	 *       HKDF-Expand(Secret, HkdfLabel, Length)
+	 *
+	 *  Where HkdfLabel is specified as:
+	 *
+	 *  struct {
+	 *      uint16 length = Length;
+	 *      opaque label<7..255> = "tls13 " + Label;
+	 *      opaque context<0..255> = Context;
+	 *  } HkdfLabel;
+	 */
+	put_unaligned_be16(key->len, p);
+	p += 2;
+	*p++ = (u8)(sizeof(LABEL) - 1 + label->len);
+	p = quic_put_data(p, LABEL, sizeof(LABEL) - 1);
+	p = quic_put_data(p, label->data, label->len);
+	*p++ = 0;
+	infolen = (unsigned int)(p - info);
+
+	err = crypto_shash_setkey(tfm, srt->data, srt->len);
+	if (err)
+		return err;
+	desc->tfm = tfm;
+
+	for (i = 0; i < key->len; i += hashlen) {
+		err = crypto_shash_init(desc);
+		if (err)
+			goto out;
+
+		if (prev) {
+			err = crypto_shash_update(desc, prev, hashlen);
+			if (err)
+				goto out;
+		}
+
+		err = crypto_shash_update(desc, info, infolen);
+		if (err)
+			goto out;
+
+		BUILD_BUG_ON(sizeof(cnt) != 1);
+		if (key->len - i < hashlen) {
+			err = crypto_shash_finup(desc, &cnt, 1, tmp);
+			if (err)
+				goto out;
+			memcpy(&key->data[i], tmp, key->len - i);
+			memzero_explicit(tmp, sizeof(tmp));
+		} else {
+			err = crypto_shash_finup(desc, &cnt, 1, &key->data[i]);
+			if (err)
+				goto out;
+		}
+		cnt++;
+		prev = &key->data[i];
+	}
+out:
+	shash_desc_zero(desc);
+	memzero_explicit(tmp, sizeof(tmp));
+	return err;
+}
+
+#define KEY_LABEL_V1		"quic key"
+#define IV_LABEL_V1		"quic iv"
+#define HP_KEY_LABEL_V1		"quic hp"
+
+#define KU_LABEL_V1		"quic ku"
+
+/* rfc9369#section-3.3.2:
+ *
+ * The labels used in rfc9001 to derive packet protection keys, header
+ * protection keys, Retry Integrity Tag keys, and key updates change from "quic
+ * key" to "quicv2 key", from "quic iv" to "quicv2 iv", from "quic hp" to
+ * "quicv2 hp", and from "quic ku" to "quicv2 ku".
+ */
+#define KEY_LABEL_V2		"quicv2 key"
+#define IV_LABEL_V2		"quicv2 iv"
+#define HP_KEY_LABEL_V2		"quicv2 hp"
+
+#define KU_LABEL_V2		"quicv2 ku"
+
+/* Packet Protection Keys. */
+static int quic_crypto_keys_derive(struct crypto_shash *tfm,
+				   struct quic_data *s, struct quic_data *k,
+				   struct quic_data *i, struct quic_data *hp_k,
+				   u32 version)
+{
+	struct quic_data hp_k_l = {HP_KEY_LABEL_V1, strlen(HP_KEY_LABEL_V1)};
+	struct quic_data k_l = {KEY_LABEL_V1, strlen(KEY_LABEL_V1)};
+	struct quic_data i_l = {IV_LABEL_V1, strlen(IV_LABEL_V1)};
+	int err;
+
+	/* rfc9001#section-5.1:
+	 *
+	 * The current encryption level secret and the label "quic key" are
+	 * input to the KDF to produce the AEAD key; the label "quic iv" is
+	 * used to derive the Initialization Vector (IV). The header protection
+	 * key uses the "quic hp" label.  Using these labels provides key
+	 * separation between QUIC and TLS.
+	 */
+	if (version == QUIC_VERSION_V2) {
+		quic_data(&hp_k_l, HP_KEY_LABEL_V2, strlen(HP_KEY_LABEL_V2));
+		quic_data(&k_l, KEY_LABEL_V2, strlen(KEY_LABEL_V2));
+		quic_data(&i_l, IV_LABEL_V2, strlen(IV_LABEL_V2));
+	}
+
+	err = quic_crypto_hkdf_expand(tfm, s, &k_l, k);
+	if (err)
+		return err;
+	err = quic_crypto_hkdf_expand(tfm, s, &i_l, i);
+	if (err)
+		return err;
+	/* Don't change hp key for key update. */
+	if (!hp_k)
+		return 0;
+
+	return quic_crypto_hkdf_expand(tfm, s, &hp_k_l, hp_k);
+}
+
+/* Derive and install reception (RX) or transmission (TX) packet protection
+ * keys for a specified key phase. This installs AEAD protection key, IV, and
+ * optionally header protection key (only when not doing key update).
+ */
+static int quic_crypto_keys_derive_and_install(struct quic_crypto *crypto,
+					       bool rx, u8 phase)
+{
+	struct quic_data srt = {}, k, iv, hp_k = {}, *hp = NULL;
+	u8 key[QUIC_KEY_LEN], hp_key[QUIC_KEY_LEN] = {};
+	u32 keylen, ivlen = QUIC_IV_LEN;
+	struct crypto_skcipher *hp_tfm;
+	struct crypto_aead *tfm;
+	int err;
+
+	keylen = crypto->cipher->keylen;
+	quic_data(&k, key, keylen);
+
+	if (rx) {
+		quic_data(&srt, crypto->rx_secret[phase],
+			  crypto->cipher->secretlen);
+		quic_data(&iv, crypto->rx_iv[phase], ivlen);
+		tfm = crypto->rx_tfm[phase];
+		hp_tfm = crypto->rx_hp_tfm;
+	} else {
+		crypto->tx_count[phase] = 0;
+		quic_data(&srt, crypto->tx_secret[phase],
+			  crypto->cipher->secretlen);
+		quic_data(&iv, crypto->tx_iv[phase], ivlen);
+		tfm = crypto->tx_tfm[phase];
+		hp_tfm = crypto->tx_hp_tfm;
+	}
+
+	/* Only derive header protection key when not in key update. */
+	if (crypto->key_phase == phase)
+		hp = quic_data(&hp_k, hp_key, keylen);
+	err = quic_crypto_keys_derive(crypto->secret_tfm, &srt, &k, &iv, hp,
+				      crypto->version);
+	if (err)
+		goto out;
+	err = crypto_aead_setauthsize(tfm, QUIC_TAG_LEN);
+	if (err)
+		goto out;
+	err = crypto_aead_setkey(tfm, key, keylen);
+	if (err)
+		goto out;
+	if (hp) {
+		err = crypto_skcipher_setkey(hp_tfm, hp_key, keylen);
+		if (err)
+			goto out;
+	}
+out:
+	memzero_explicit(key, sizeof(key));
+	memzero_explicit(hp_key, sizeof(hp_key));
+	return err;
+}
+
+#define QUIC_CIPHER_MIN TLS_CIPHER_AES_GCM_128
+#define QUIC_CIPHER_MAX TLS_CIPHER_CHACHA20_POLY1305
+
+#define TLS_CIPHER_AES_GCM_128_SECRET_SIZE		32
+#define TLS_CIPHER_AES_GCM_256_SECRET_SIZE		48
+#define TLS_CIPHER_AES_CCM_128_SECRET_SIZE		32
+#define TLS_CIPHER_CHACHA20_POLY1305_SECRET_SIZE	32
+
+#define CIPHER_DESC(type, aead_n, skc_n, sha_n, \
+		    tx_lim, rx_lim)[type - QUIC_CIPHER_MIN] = { \
+	.secretlen = type ## _SECRET_SIZE, \
+	.keylen = type ## _KEY_SIZE, \
+	.aead = aead_n, \
+	.skc = skc_n, \
+	.shash = sha_n, \
+	.txlimit = tx_lim, \
+	.rxlimit = rx_lim, \
+}
+
+/* rfc9001#section-6.6: AEAD Usage Limits */
+#define QUIC_AEAD_TX_AES_GCM		BIT_ULL(23)
+#define QUIC_AEAD_TX_AES_CCM		2965820ULL /* 2^21.5 */
+#define QUIC_AEAD_TX_CHACHA		BIT_ULL(62)
+
+#define QUIC_AEAD_RX_AES_GCM		BIT_ULL(52)
+#define QUIC_AEAD_RX_AES_CCM		2965820ULL /* 2^21.5 */
+#define QUIC_AEAD_RX_CHACHA		BIT_ULL(36)
+
+static const struct quic_cipher
+ciphers[QUIC_CIPHER_MAX + 1 - QUIC_CIPHER_MIN] = {
+	CIPHER_DESC(TLS_CIPHER_AES_GCM_128,
+		    "gcm(aes)", "ecb(aes)", "hmac(sha256)",
+		    QUIC_AEAD_TX_AES_GCM, QUIC_AEAD_RX_AES_GCM),
+	CIPHER_DESC(TLS_CIPHER_AES_GCM_256,
+		    "gcm(aes)", "ecb(aes)", "hmac(sha384)",
+		    QUIC_AEAD_TX_AES_GCM, QUIC_AEAD_RX_AES_GCM),
+	CIPHER_DESC(TLS_CIPHER_AES_CCM_128,
+		    "ccm(aes)", "ecb(aes)", "hmac(sha256)",
+		    QUIC_AEAD_TX_AES_CCM, QUIC_AEAD_RX_AES_CCM),
+	CIPHER_DESC(TLS_CIPHER_CHACHA20_POLY1305,
+		    "rfc7539(chacha20,poly1305)", "chacha20", "hmac(sha256)",
+		    QUIC_AEAD_TX_CHACHA, QUIC_AEAD_RX_CHACHA),
+};
+
+int quic_crypto_set_cipher(struct quic_crypto *crypto, u32 type)
+{
+	const struct quic_cipher *cipher;
+	void *tfm;
+	int err;
+
+	if (type < QUIC_CIPHER_MIN || type > QUIC_CIPHER_MAX)
+		return -EINVAL;
+
+	cipher = &ciphers[type - QUIC_CIPHER_MIN];
+	tfm = crypto_alloc_shash(cipher->shash, 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+	crypto->secret_tfm = tfm;
+
+	/* Allocate AEAD transform for each RX key phase and a single HP
+	 * transform shared by both phases.
+	 */
+	tfm = crypto_alloc_aead(cipher->aead, 0, 0);
+	if (IS_ERR(tfm)) {
+		err = PTR_ERR(tfm);
+		goto err;
+	}
+	crypto->rx_tfm[0] = tfm;
+	tfm = crypto_alloc_aead(cipher->aead, 0, 0);
+	if (IS_ERR(tfm)) {
+		err = PTR_ERR(tfm);
+		goto err;
+	}
+	crypto->rx_tfm[1] = tfm;
+	tfm = crypto_alloc_sync_skcipher(cipher->skc, 0, 0);
+	if (IS_ERR(tfm)) {
+		err = PTR_ERR(tfm);
+		goto err;
+	}
+	crypto->rx_hp_tfm = tfm;
+
+	/* Allocate AEAD transform for each TX key phase and a single HP
+	 * transform shared by both phases.
+	 */
+	tfm = crypto_alloc_aead(cipher->aead, 0, 0);
+	if (IS_ERR(tfm)) {
+		err = PTR_ERR(tfm);
+		goto err;
+	}
+	crypto->tx_tfm[0] = tfm;
+	tfm = crypto_alloc_aead(cipher->aead, 0, 0);
+	if (IS_ERR(tfm)) {
+		err = PTR_ERR(tfm);
+		goto err;
+	}
+	crypto->tx_tfm[1] = tfm;
+	tfm = crypto_alloc_sync_skcipher(cipher->skc, 0, 0);
+	if (IS_ERR(tfm)) {
+		err = PTR_ERR(tfm);
+		goto err;
+	}
+	crypto->tx_hp_tfm = tfm;
+
+	crypto->cipher = cipher;
+	crypto->cipher_type = type;
+	return 0;
+err:
+	quic_crypto_free(crypto);
+	return err;
+}
+
+int quic_crypto_set_secret(struct quic_crypto *crypto,
+			   struct quic_crypto_secret *srt, u32 version)
+{
+	const struct quic_cipher *cipher;
+	u8 phase = crypto->key_phase;
+	int err;
+
+	/* If no cipher has been initialized yet, set it up. */
+	if (!crypto->cipher) {
+		err = quic_crypto_set_cipher(crypto, srt->type);
+		if (err)
+			return err;
+	} else if (crypto->cipher_type != srt->type) {
+		return -EINVAL;
+	}
+	cipher = crypto->cipher;
+
+	/* Handle RX path setup. */
+	if (!srt->send) {
+		crypto->version = version;
+		memcpy(crypto->rx_secret[phase], srt->secret,
+		       cipher->secretlen);
+		err = quic_crypto_keys_derive_and_install(crypto, true, phase);
+		if (err)
+			return err;
+		crypto->recv_ready = 1;
+		return 0;
+	}
+
+	/* Handle TX path setup. */
+	crypto->version = version;
+	memcpy(crypto->tx_secret[phase], srt->secret, cipher->secretlen);
+	err = quic_crypto_keys_derive_and_install(crypto, false, phase);
+	if (err)
+		return err;
+	crypto->send_ready = 1;
+	return 0;
+}
+
+/* Save token secret in Initial TX secret (phase 1) for token generation. */
+int quic_crypto_set_token_secret(struct quic_crypto *crypto)
+{
+	/* Reuse TX AEAD (phase 1) in Initial crypto. */
+	u8 key[TLS_CIPHER_AES_GCM_128_KEY_SIZE], *srt = crypto->tx_secret[1];
+	struct crypto_aead *tfm = crypto->tx_tfm[1];
+	struct quic_data s = {}, k, i;
+	int err;
+
+	if (!memchr_inv(srt, 0, TLS_CIPHER_AES_GCM_128_SECRET_SIZE))
+		get_random_bytes(srt, TLS_CIPHER_AES_GCM_128_SECRET_SIZE);
+
+	quic_data(&s, srt, TLS_CIPHER_AES_GCM_128_SECRET_SIZE);
+	quic_data(&k, key, TLS_CIPHER_AES_GCM_128_KEY_SIZE);
+	quic_data(&i, crypto->tx_iv[1], QUIC_IV_LEN);
+	err = quic_crypto_keys_derive(crypto->secret_tfm, &s, &k, &i, NULL,
+				      QUIC_VERSION_V1);
+	if (err)
+		goto out;
+	err = crypto_aead_setauthsize(tfm, QUIC_TAG_LEN);
+	if (err)
+		goto out;
+	err = crypto_aead_setkey(tfm, key, TLS_CIPHER_AES_GCM_128_KEY_SIZE);
+	if (err)
+		goto out;
+	get_random_bytes(&crypto->tx_count[1], sizeof(crypto->tx_count[1]));
+out:
+	memzero_explicit(key, sizeof(key));
+	return err;
+}
+
+/* Initiating a Key Update. */
+int quic_crypto_key_update(struct quic_crypto *crypto)
+{
+	struct quic_data l = {KU_LABEL_V1, strlen(KU_LABEL_V1)};
+	u8 phase = crypto->key_phase;
+	struct quic_data k, srt;
+	u32 secret_len;
+	int err;
+
+	if (crypto->key_pending || !crypto->recv_ready)
+		return -EINVAL;
+	if (crypto->key_derived)
+		return 0;
+
+	/* rfc9001#section-6.1:
+	 *
+	 * Endpoints maintain separate read and write secrets for packet
+	 * protection. An endpoint initiates a key update by updating its
+	 * packet protection write secret and using that to protect new
+	 * packets. The endpoint creates a new write secret from the existing
+	 * write secret. This uses the KDF function provided by TLS with a
+	 * label of "quic ku". The corresponding key and IV are created from
+	 * that secret. The header protection key is not updated.
+	 *
+	 * For example, to update write keys with TLS 1.3, HKDF-Expand-Label is
+	 * used as:
+	 *   secret_<n+1> = HKDF-Expand-Label(secret_<n>, "quic ku",
+	 *                                    "", Hash.length)
+	 */
+	secret_len = crypto->cipher->secretlen;
+	if (crypto->version == QUIC_VERSION_V2)
+		quic_data(&l, KU_LABEL_V2, strlen(KU_LABEL_V2));
+
+	quic_data(&srt, crypto->tx_secret[phase], secret_len);
+	quic_data(&k, crypto->tx_secret[!phase], secret_len);
+	err = quic_crypto_hkdf_expand(crypto->secret_tfm, &srt, &l, &k);
+	if (err)
+		return err;
+	err = quic_crypto_keys_derive_and_install(crypto, false, !phase);
+	if (err)
+		return err;
+
+	quic_data(&srt, crypto->rx_secret[phase], secret_len);
+	quic_data(&k, crypto->rx_secret[!phase], secret_len);
+	err = quic_crypto_hkdf_expand(crypto->secret_tfm, &srt, &l, &k);
+	if (err)
+		return err;
+	err = quic_crypto_keys_derive_and_install(crypto, true, !phase);
+	if (err)
+		return err;
+
+	crypto->key_derived = 1;
+	return 0;
+}
+
+void quic_crypto_free(struct quic_crypto *crypto)
+{
+	if (crypto->rx_tfm[0])
+		crypto_free_aead(crypto->rx_tfm[0]);
+	if (crypto->rx_tfm[1])
+		crypto_free_aead(crypto->rx_tfm[1]);
+	if (crypto->tx_tfm[0])
+		crypto_free_aead(crypto->tx_tfm[0]);
+	if (crypto->tx_tfm[1])
+		crypto_free_aead(crypto->tx_tfm[1]);
+	if (crypto->secret_tfm)
+		crypto_free_shash(crypto->secret_tfm);
+	if (crypto->rx_hp_tfm)
+		crypto_free_skcipher(crypto->rx_hp_tfm);
+	if (crypto->tx_hp_tfm)
+		crypto_free_skcipher(crypto->tx_hp_tfm);
+
+	memzero_explicit(crypto, offsetof(struct quic_crypto, send_offset));
+}
+
+#define QUIC_INITIAL_SALT_V1 \
+	"\x38\x76\x2c\xf7\xf5\x59\x34\xb3\x4d\x17" \
+	"\x9a\xe6\xa4\xc8\x0c\xad\xcc\xbb\x7f\x0a"
+
+#define QUIC_INITIAL_SALT_V2 \
+	"\x0d\xed\xe3\xde\xf7\x00\xa6\xdb\x81\x93" \
+	"\x81\xbe\x6e\x26\x9d\xcb\xf9\xbd\x2e\xd9"
+
+#define QUIC_INITIAL_SALT_LEN	20
+
+/* Initial Secrets. */
+int quic_crypto_initial_keys_install(struct quic_crypto *crypto,
+				     struct quic_conn_id *conn_id,
+				     u32 version, bool is_serv)
+{
+	u8 secret[TLS_CIPHER_AES_GCM_128_SECRET_SIZE];
+	struct quic_data salt, s, k, l, dcid;
+	struct quic_crypto_secret srt = {};
+	char *tl, *rl, *sal;
+	int err;
+
+	/* rfc9001#section-5.2:
+	 *
+	 * The secret used by clients to construct Initial packets uses the PRK
+	 * and the label "client in" as input to the HKDF-Expand-Label function
+	 * from TLS [TLS13] to produce a 32-byte secret. Packets constructed by
+	 * the server use the same process with the label "server in". The hash
+	 * function for HKDF when deriving initial secrets and keys is SHA-256
+	 * [SHA].
+	 *
+	 * This process in pseudocode is:
+	 *
+	 *   initial_salt = 0x38762cf7f55934b34d179ae6a4c80cadccbb7f0a
+	 *   initial_secret = HKDF-Extract(initial_salt,
+	 *                                 client_dst_connection_id)
+	 *
+	 *   client_initial_secret = HKDF-Expand-Label(initial_secret,
+	 *                                             "client in", "",
+	 *                                             Hash.length)
+	 *   server_initial_secret = HKDF-Expand-Label(initial_secret,
+	 *                                             "server in", "",
+	 *                                             Hash.length)
+	 */
+	if (is_serv) {
+		rl = "client in";
+		tl = "server in";
+	} else {
+		tl = "client in";
+		rl = "server in";
+	}
+	sal = QUIC_INITIAL_SALT_V1;
+	if (version == QUIC_VERSION_V2)
+		sal = QUIC_INITIAL_SALT_V2;
+	quic_data(&salt, sal, QUIC_INITIAL_SALT_LEN);
+	quic_data(&dcid, conn_id->data, conn_id->len);
+	quic_data(&s, secret, TLS_CIPHER_AES_GCM_128_SECRET_SIZE);
+	err = quic_crypto_hkdf_extract(crypto->secret_tfm, &salt, &dcid, &s);
+	if (err)
+		goto out;
+
+	quic_data(&l, tl, strlen(tl));
+	quic_data(&k, srt.secret, TLS_CIPHER_AES_GCM_128_SECRET_SIZE);
+	srt.type = TLS_CIPHER_AES_GCM_128;
+	srt.send = 1;
+	err = quic_crypto_hkdf_expand(crypto->secret_tfm, &s, &l, &k);
+	if (err)
+		goto out;
+	err = quic_crypto_set_secret(crypto, &srt, version);
+	if (err)
+		goto out;
+
+	quic_data(&l, rl, strlen(rl));
+	quic_data(&k, srt.secret, TLS_CIPHER_AES_GCM_128_SECRET_SIZE);
+	srt.type = TLS_CIPHER_AES_GCM_128;
+	srt.send = 0;
+	err = quic_crypto_hkdf_expand(crypto->secret_tfm, &s, &l, &k);
+	if (err)
+		goto out;
+	err = quic_crypto_set_secret(crypto, &srt, version);
+out:
+	memzero_explicit(secret, sizeof(secret));
+	memzero_explicit(&srt, sizeof(srt));
+	return err;
+}
+
+/* Derive a secret using HKDF-Extract and HKDF-Expand with the given label.
+ * Used to generate a stateless reset token or session resumption master key.
+ */
+int quic_crypto_derive_secret(struct quic_crypto *crypto, void *data, u32 len,
+			      char *label, u8 *srt, u32 srt_len)
+{
+	struct crypto_shash *tfm = crypto->secret_tfm;
+	u8 secret[TLS_CIPHER_AES_GCM_128_SECRET_SIZE];
+	struct quic_data salt, s, l, k;
+	int err;
+
+	quic_data(&salt, data, len);
+	quic_data(&k, crypto->tx_secret[1], TLS_CIPHER_AES_GCM_128_SECRET_SIZE);
+	quic_data(&s, secret, TLS_CIPHER_AES_GCM_128_SECRET_SIZE);
+	err = quic_crypto_hkdf_extract(tfm, &salt, &k, &s);
+	if (err)
+		goto out;
+
+	quic_data(&l, label, strlen(label));
+	quic_data(&k, srt, srt_len);
+	err = quic_crypto_hkdf_expand(tfm, &s, &l, &k);
+out:
+	memzero_explicit(secret, sizeof(secret));
+	return err;
+}
diff --git a/net/quic/crypto.h b/net/quic/crypto.h
new file mode 100644
index 000000000000..29eaf0cbd2e1
--- /dev/null
+++ b/net/quic/crypto.h
@@ -0,0 +1,90 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* QUIC kernel implementation
+ * (C) Copyright Red Hat Corp. 2023
+ *
+ * This file is part of the QUIC kernel implementation
+ *
+ * Written or modified by:
+ *    Xin Long <lucien.xin@gmail.com>
+ */
+
+#define QUIC_TAG_LEN	16
+#define QUIC_IV_LEN	12
+#define QUIC_KEY_LEN	32
+#define QUIC_SECRET_LEN	48
+
+#define QUIC_TOKEN_FLAG_REGULAR		0
+#define QUIC_TOKEN_FLAG_RETRY		1
+#define QUIC_TOKEN_TIMEOUT_RETRY	3000000
+#define QUIC_TOKEN_TIMEOUT_REGULAR	600000000
+
+struct quic_cipher {
+	u32 secretlen; /* Length of the traffic secret */
+	u32 keylen;    /* Length of the AEAD key */
+
+	char *shash; /* Name of hash algorithm used for key derivation */
+	char *aead;  /* Name of AEAD algorithm used for payload en/decryption */
+	char *skc;   /* Name of cipher algorithm used for header protection */
+
+	u64 txlimit; /* Max packets encrypted per key */
+	u64 rxlimit; /* Max decryption failures per crypto level */
+};
+
+struct quic_crypto {
+	struct crypto_skcipher *tx_hp_tfm; /* TX header protection tfm */
+	struct crypto_skcipher *rx_hp_tfm; /* RX header protection tfm */
+	struct crypto_shash *secret_tfm;   /* Key derivation (HKDF) tfm */
+	struct crypto_aead *tx_tfm[2]; /* AEAD tfm for TX (key phase 0 and 1) */
+	struct crypto_aead *rx_tfm[2]; /* AEAD tfm for RX (key phase 0 and 1) */
+
+	const struct quic_cipher *cipher;  /* Cipher info (selected cipher) */
+	u32 cipher_type; /* Cipher suite (e.g., AES_GCM_128, etc.) */
+
+	u8 tx_secret[2][QUIC_SECRET_LEN]; /* TX secret (key phase 0 and 1) */
+	u8 rx_secret[2][QUIC_SECRET_LEN]; /* RX secret (key phase 0 and 1) */
+	u8 tx_iv[2][QUIC_IV_LEN];      /* IVs for TX (key phase 0 and 1) */
+	u8 rx_iv[2][QUIC_IV_LEN];      /* IVs for RX (key phase 0 and 1) */
+	atomic_t async_pending[2]; /* Async pending count (key phase 0 and 1) */
+	u64 tx_count[2];           /* Packets encrypted (key phase 0 and 1) */
+
+	/* Timestamp 1st packet sent after key update */
+	u64 key_update_send_time;
+	u64 key_update_time; /* Duration to retain old keys after key update */
+	u64 rx_fails;        /* Failures decrypted */
+	u32 version;         /* QUIC version in use */
+
+	u8 ticket_ready:1; /* True if a session ticket is ready to read */
+	u8 key_pending:1;  /* A key update is in progress */
+	u8 key_derived:1;  /* Key derived for the key update */
+	u8 send_ready:1;   /* TX encryption context is initialized */
+	u8 recv_ready:1;   /* RX decryption context is initialized */
+	u8 key_phase:1;    /* Current key phase being used (0 or 1) */
+
+	u64 send_offset; /* Number of handshake bytes sent by user */
+	u64 recv_offset; /* Number of handshake bytes read by user */
+
+	struct work_struct work; /* Workqueue to destroy crypto */
+};
+
+/* Mark crypto context inactive without freeing transforms; async ops may still
+ * be in flight. Actual transform cleanup is deferred to quic_sock_destruct().
+ */
+static inline void quic_crypto_discard(struct quic_crypto *crypto)
+{
+	crypto->recv_ready = 0;
+	crypto->send_ready = 0;
+}
+
+int quic_crypto_set_secret(struct quic_crypto *crypto,
+			   struct quic_crypto_secret *srt, u32 version);
+int quic_crypto_set_cipher(struct quic_crypto *crypto, u32 type);
+int quic_crypto_key_update(struct quic_crypto *crypto);
+
+int quic_crypto_derive_secret(struct quic_crypto *crypto, void *data, u32 len,
+			      char *label, u8 *srt, u32 srt_len);
+int quic_crypto_initial_keys_install(struct quic_crypto *crypto,
+				     struct quic_conn_id *conn_id,
+				     u32 version, bool is_serv);
+int quic_crypto_set_token_secret(struct quic_crypto *crypto);
+
+void quic_crypto_free(struct quic_crypto *crypto);
diff --git a/net/quic/socket.c b/net/quic/socket.c
index 78a08dd998a8..d717efca9b9e 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -40,11 +40,38 @@ static void quic_write_space(struct sock *sk)
 	rcu_read_unlock();
 }
 
+static void quic_crypto_free_work(struct work_struct *w)
+{
+	struct quic_crypto *crypto = container_of(w, struct quic_crypto, work);
+
+	/* Deferred crypto cleanup in process context. */
+	quic_crypto_free(crypto);
+	kfree(crypto);
+}
+
+static void quic_sock_destruct(struct sock *sk)
+{
+	struct quic_crypto *crypto;
+	u8 i;
+
+	/* Deferred crypto free for async encryption/decryption. */
+	for (i = 0; i < QUIC_CRYPTO_MAX; i++) {
+		crypto = quic_crypto(sk, i);
+		if (!crypto)
+			continue;
+		queue_work(quic_wq, &crypto->work);
+	}
+
+	quic_sk_destruct(sk);
+}
+
 static int quic_init_sock(struct sock *sk)
 {
 	struct quic_pnspace *space;
+	struct quic_crypto *crypto;
 	u8 i;
 
+	sk->sk_destruct = quic_sock_destruct;
 	sk->sk_write_space = quic_write_space;
 	sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
 	sock_set_flag(sk, SOCK_RCU_FREE);
@@ -73,6 +100,15 @@ static int quic_init_sock(struct sock *sk)
 		quic_sk(sk)->space[i] = space;
 	}
 
+	/* Allocate crypto structures for each encryption level. */
+	for (i = 0; i < QUIC_CRYPTO_MAX; i++) {
+		crypto = kzalloc_obj(*crypto);
+		if (!crypto)
+			return -ENOMEM;
+		INIT_WORK(&crypto->work, quic_crypto_free_work);
+		quic_sk(sk)->crypto[i] = crypto;
+	}
+
 	return 0;
 }
 
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 7f19e2b3d7fb..ece21b9120fc 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -16,6 +16,7 @@
 #include "family.h"
 #include "stream.h"
 #include "connid.h"
+#include "crypto.h"
 #include "path.h"
 #include "cong.h"
 
@@ -45,6 +46,7 @@ struct quic_sock {
 	struct quic_path_group		paths;
 	struct quic_cong		cong;
 	struct quic_pnspace		*space[QUIC_PNSPACE_MAX];
+	struct quic_crypto		*crypto[QUIC_CRYPTO_MAX];
 };
 
 struct quic6_sock {
@@ -112,6 +114,11 @@ static inline struct quic_pnspace *quic_pnspace(const struct sock *sk, u8 level)
 	return quic_sk(sk)->space[level % QUIC_CRYPTO_EARLY];
 }
 
+static inline struct quic_crypto *quic_crypto(const struct sock *sk, u8 level)
+{
+	return quic_sk(sk)->crypto[level];
+}
+
 static inline bool quic_is_establishing(struct sock *sk)
 {
 	return sk->sk_state == QUIC_SS_ESTABLISHING;
-- 
2.47.1

