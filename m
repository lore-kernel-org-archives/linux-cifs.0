Return-Path: <SRS0=ILFa=ZG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759AFC432C3
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Nov 2019 01:39:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EA15206D7
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Nov 2019 01:39:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eEvBLyiQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfKNBju (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Nov 2019 20:39:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40700 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726098AbfKNBju (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Nov 2019 20:39:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573695588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w9CJtYmVNPcjg3JOZ1IHCfU/uY2XCNyqfyvFlnnZoOM=;
        b=eEvBLyiQOn4pdo19KNwT6FMGwEZgWUN7rdHvz7f+x3Pv+IS+WkxORZJufRY2ekqaL6Zmac
        icpErLm8ixSH1VPyNCQHWjKB5NB8jmVqZ6AiU+19EkT3JKBiWCgp0bNfEK3DZUKXN9jwBc
        8ct8pAKb03La6G7NhFn4q3t7nrhOukI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-RRoeH45CP2--vP4hgLv90Q-1; Wed, 13 Nov 2019 20:39:45 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9F9E1802CE0;
        Thu, 14 Nov 2019 01:39:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A260861341;
        Thu, 14 Nov 2019 01:39:44 +0000 (UTC)
Received: from zmail25.collab.prod.int.phx2.redhat.com (zmail25.collab.prod.int.phx2.redhat.com [10.5.83.31])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9396718095FF;
        Thu, 14 Nov 2019 01:39:44 +0000 (UTC)
Date:   Wed, 13 Nov 2019 20:39:44 -0500 (EST)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     Frank Sorenson <sorenson@redhat.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Message-ID: <1468784979.11678511.1573695584530.JavaMail.zimbra@redhat.com>
In-Reply-To: <9195bac2-e271-537b-e1a0-8736efc80771@redhat.com>
References: <0326b8d9-d66c-1df0-2d04-91b9a861c10f@redhat.com> <CAKywueQ4nx2=V889Ty40QZOfoVij7Wp4dmhuhHV4A6mhGpgYAA@mail.gmail.com> <579288007.11441637.1573622351338.JavaMail.zimbra@redhat.com> <81694688.11451093.1573627786969.JavaMail.zimbra@redhat.com> <9195bac2-e271-537b-e1a0-8736efc80771@redhat.com>
Subject: Re: A process killed while opening a file can result in leaked open
 handle on the server
MIME-Version: 1.0
X-Originating-IP: [10.64.54.39, 10.4.195.25]
Thread-Topic: A process killed while opening a file can result in leaked open handle on the server
Thread-Index: jW+KnwjvU6SVEpLe1R+T54Zttj5bKw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: RRoeH45CP2--vP4hgLv90Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org





----- Original Message -----
> From: "Frank Sorenson" <sorenson@redhat.com>
> To: "Ronnie Sahlberg" <lsahlber@redhat.com>, "Pavel Shilovsky" <piastryyy=
@gmail.com>
> Cc: "linux-cifs" <linux-cifs@vger.kernel.org>
> Sent: Thursday, 14 November, 2019 8:15:46 AM
> Subject: Re: A process killed while opening a file can result in leaked o=
pen handle on the server
>=20
> On 11/13/19 12:49 AM, Ronnie Sahlberg wrote:
> > Steve, Pavel
> >=20
> > This patch goes ontop of Pavels patch.
> > Maybe it should be merged with Pavels patch since his patch changes fro=
m
> > "we only send a close() on an interrupted open()"
> > to now "we send a close() on either interrupted open() or interrupted
> > close()" so both comments as well as log messages are updates.
> >=20
> > Additionally it adds logging of the MID that failed in the case of an
> > interrupted Open() so that it is easy to find it in wireshark
> > and check whether that smb2 file handle was indeed handles by a SMB_Clo=
se()
> > or not.
> >=20
> >=20
> > From testing it appears Pavels patch works. When the close() is interru=
pted
> > we don't leak handles as far as I can tell.
> > We do have a leak in the Open() case though and it seems that eventhoug=
h we
> > set things up and flags the MID to be cancelled we actually never end u=
p
> > calling smb2_cancelled_close_fid() and thus we never send a SMB2_Close(=
).
> > I haven't found the root cause yet but I suspect we mess up mid flags o=
r
> > state somewhere.
> >=20
> >=20
> > It did work in the past though when Sachin provided the initial
> > implementation so we have regressed I think.
> > I have added a new test 'cifs/102'  to the buildbot that checks for thi=
s
> > but have not integrated into the cifs-testing run yet since we still fa=
il
> > this test.
> > At least we will not have further regressions once we fix this and enab=
le
> > the test in the future.
> >=20
> > ronnie s
>=20
> The patches do indeed improve it significantly.
>=20
> I'm still seeing some leak as well, and I'm removing ratelimiting so
> that I can see what the added debugging is trying to tell us.  I'll
> report if I find more details.
>=20

We are making progress.
Can you test this patch if it improves even more for you?
It fixes most but not all the leaks I see for interrupted open():

I will post this to the list too as a separate mail/patch.


Author: Ronnie Sahlberg <lsahlber@redhat.com>
Date:   Thu Nov 14 11:23:06 2019 +1000

    cifs: fix race between compound_send_recv() and the demultiplex thread
   =20
    There is a race where the open() may be interrupted between when we rec=
eive the reply
    but before we have invoked the callback in which case we never end up c=
alling
    handle_cancelled_mid() and thus leak an open handle on the server.
   =20
    Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ccaa8bad336f..802604a7e692 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1223,7 +1223,6 @@ cifs_demultiplex_thread(void *p)
                        if (mids[i] !=3D NULL) {
                                mids[i]->resp_buf_size =3D server->pdu_size=
;
                                if ((mids[i]->mid_flags & MID_WAIT_CANCELLE=
D) &&
-                                   mids[i]->mid_state =3D=3D MID_RESPONSE_=
RECEIVED &&
                                    server->ops->handle_cancelled_mid)
                                        server->ops->handle_cancelled_mid(
                                                        mids[i]->resp_buf,
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index ca3de62688d6..28018a7eccb2 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -1119,7 +1119,8 @@ compound_send_recv(const unsigned int xid, struct cif=
s_ses *ses,
                                 midQ[i]->mid, le16_to_cpu(midQ[i]->command=
));
                        send_cancel(server, &rqst[i], midQ[i]);
                        spin_lock(&GlobalMid_Lock);
-                       if (midQ[i]->mid_state =3D=3D MID_REQUEST_SUBMITTED=
) {
+                       if (midQ[i]->mid_state =3D=3D MID_REQUEST_SUBMITTED=
 ||
+                           midQ[i]->mid_state =3D=3D MID_RESPONSE_RECEIVED=
) {
                                midQ[i]->mid_flags |=3D MID_WAIT_CANCELLED;
                                midQ[i]->callback =3D cifs_cancelled_callba=
ck;
                                cancelled_mid[i] =3D true;





>=20
> Thanks for the help.
>=20
>=20
> Frank
>=20
>=20

