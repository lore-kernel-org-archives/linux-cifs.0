Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B8A0C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Dec 2021 18:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239950AbhLCSo7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Dec 2021 13:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235199AbhLCSo7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Dec 2021 13:44:59 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5C5C061751
        for <linux-cifs@vger.kernel.org>; Fri,  3 Dec 2021 10:41:34 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id m27so8529987lfj.12
        for <linux-cifs@vger.kernel.org>; Fri, 03 Dec 2021 10:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SF9LE+LPSRE2ucpW+f2mkpPTMAq2jUVPSiHZ5CXrd7w=;
        b=jXdVWPQCykalbWvz64ZX4gYwejc33g/928cehdnbUEvHAPvB4DhjvtKvs7ni37gve7
         7TY5EIkqNYiyqDGXsMig96DYNxi4bHHAB9OavOcv99wtC9UAtkG4Q2oawlZq8SJfagAN
         +jnyaOWsazX9l/16uSjK4yQbqUfqhWPDJEqtVycEmNUHMx8QMAUbM8toUmCAGI2fe5sQ
         5FGD5ZhTt8zDM+4RJmIkVpuZzHlHFCMaC0L3cfHNCP1MOE25iWBc0O05QT3MtR92vJtY
         ktY4hIpafhpm2POuCm4qxZuDeG/av0ZfjQ7O6kLfLUBy+KeGIBAgY8tjuqtWH471FCuF
         K0RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SF9LE+LPSRE2ucpW+f2mkpPTMAq2jUVPSiHZ5CXrd7w=;
        b=48xZLCrr+WXkJvCBlr6H8oNPMLWTIp/2R6x+XrG5BVYeMFHBQyU+99xSBk4rMnOLSH
         AajJn3Fd9aEhOuktyBuyRL8JPyQzzvL1PJLmWD52MthJ9qI/d61BmAHWYBEcPci7yYqM
         D+7EhB1Tf6rO+Ez/C1IdR44XcSDhRHf5sfJgUPGchVuVylJ+jm/M1aGSZ7M1OUE+UiA6
         Njjw0IGacIq36Lygjg56vZivMwMGpRDYedFmK9C7GL1/mtwxVt0nIUGUhml0Ki7zHB6V
         z9Sn7dtnf5oe8fZgMCKVwEf0vrfEQFxB5+h9z2lA6KrCtJVvjLvyGYXe8397/+gx1sNZ
         Zdqg==
X-Gm-Message-State: AOAM532QwZZ1ZQubWOtS4snCGeQnGla0UxlAUvda+qi0oL1Pul36lzty
        0he2BttVMiiDwCPjMYlvJWmpyJkjpiKAGKWke4I=
X-Google-Smtp-Source: ABdhPJycHyi1xiZb48OakAKdbq4M93ibzcXH7OBqc4UC/RHiy6Z7Nu+VaYuQRrF8Z0l2H3ABh4lqKF2Y+2PCvjLZnJE=
X-Received: by 2002:ac2:5ddb:: with SMTP id x27mr18880008lfq.595.1638556892934;
 Fri, 03 Dec 2021 10:41:32 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=pqb7MmFe+kQU67Eytm98tZB1ztr0d5Rwq44oxAq81+Dw@mail.gmail.com>
In-Reply-To: <CANT5p=pqb7MmFe+kQU67Eytm98tZB1ztr0d5Rwq44oxAq81+Dw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 3 Dec 2021 12:41:21 -0600
Message-ID: <CAH2r5mvKQMJdApwfhYkVNwgow4M1ZZ7e_JsnVqrYStD0LNXX9w@mail.gmail.com>
Subject: Re: [PATCH] cifs: add server conn_id to fscache client cookie
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@redhat.com>, Paulo Alcantara <pc@cjr.nz>,
        CIFS <linux-cifs@vger.kernel.org>, linux-cachefs@redhat.com
Content-Type: multipart/mixed; boundary="0000000000008c60f705d24241c8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000008c60f705d24241c8
Content-Type: text/plain; charset="UTF-8"

Added fix for problem (missing ifdef) pointed out by kernel test robot
+#ifdef CONFIG_CIFS_FSCACHE
+       else
+               tcp_ses->fscache = tcp_ses->primary_server->fscache;
+#endif /* CONFIG_CIFS_FSCACHE */



See attached

On Fri, Dec 3, 2021 at 3:28 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> The fscache client cookie uses the server address
> (and port) as the cookie key. This is a problem when
> nosharesock is used. Two different connections will
> use duplicate cookies. Avoid this by adding
> server->conn_id to the key, so that it's guaranteed
> that cookie will not be duplicated.
>
> Also, for secondary channels of a session, copy the
> fscache pointer from the primary channel. The primary
> channel is guaranteed not to go away as long as secondary
> channels are in use.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/cifs/connect.c |  2 ++
>  fs/cifs/fscache.c | 10 ++++++++++
>  2 files changed, 12 insertions(+)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index eee994b0925f..d8822e835cc4 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1562,6 +1562,8 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
>   /* fscache server cookies are based on primary channel only */
>   if (!CIFS_SERVER_IS_CHAN(tcp_ses))
>   cifs_fscache_get_client_cookie(tcp_ses);
> + else
> + tcp_ses->fscache = tcp_ses->primary_server->fscache;
>
>   /* queue echo request delayed work */
>   queue_delayed_work(cifsiod_wq, &tcp_ses->echo, tcp_ses->echo_interval);
> diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
> index f4da693760c1..1db3437f3b7d 100644
> --- a/fs/cifs/fscache.c
> +++ b/fs/cifs/fscache.c
> @@ -24,6 +24,7 @@ struct cifs_server_key {
>   struct in_addr ipv4_addr;
>   struct in6_addr ipv6_addr;
>   };
> + __u64 conn_id;
>  } __packed;
>
>  /*
> @@ -37,6 +38,14 @@ void cifs_fscache_get_client_cookie(struct
> TCP_Server_Info *server)
>   struct cifs_server_key key;
>   uint16_t key_len = sizeof(key.hdr);
>
> + /*
> + * Check if cookie was already initialized so don't reinitialize it.
> + * In the future, as we integrate with newer fscache features,
> + * we may want to instead add a check if cookie has changed
> + */
> + if (server->fscache)
> + return;
> +
>   memset(&key, 0, sizeof(key));
>
>   /*
> @@ -62,6 +71,7 @@ void cifs_fscache_get_client_cookie(struct
> TCP_Server_Info *server)
>   server->fscache = NULL;
>   return;
>   }
> + key.conn_id = server->conn_id;
>
>   server->fscache =
>   fscache_acquire_cookie(cifs_fscache_netfs.primary_index,



-- 
Thanks,

Steve

--0000000000008c60f705d24241c8
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-add-server-conn_id-to-fscache-client-cookie.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-add-server-conn_id-to-fscache-client-cookie.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kwqqfb5z0>
X-Attachment-Id: f_kwqqfb5z0

RnJvbSAyYWRjODIwMDZiY2IwNjc1MjNiZWRkMzhlOTM3MTFjODBmZDI3NGMxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBUaHUsIDIgRGVjIDIwMjEgMDc6MzA6MDAgKzAwMDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBhZGQgc2VydmVyIGNvbm5faWQgdG8gZnNjYWNoZSBjbGllbnQgY29va2llCgpUaGUgZnNj
YWNoZSBjbGllbnQgY29va2llIHVzZXMgdGhlIHNlcnZlciBhZGRyZXNzCihhbmQgcG9ydCkgYXMg
dGhlIGNvb2tpZSBrZXkuIFRoaXMgaXMgYSBwcm9ibGVtIHdoZW4Kbm9zaGFyZXNvY2sgaXMgdXNl
ZC4gVHdvIGRpZmZlcmVudCBjb25uZWN0aW9ucyB3aWxsCnVzZSBkdXBsaWNhdGUgY29va2llcy4g
QXZvaWQgdGhpcyBieSBhZGRpbmcKc2VydmVyLT5jb25uX2lkIHRvIHRoZSBrZXksIHNvIHRoYXQg
aXQncyBndWFyYW50ZWVkCnRoYXQgY29va2llIHdpbGwgbm90IGJlIGR1cGxpY2F0ZWQuCgpBbHNv
LCBmb3Igc2Vjb25kYXJ5IGNoYW5uZWxzIG9mIGEgc2Vzc2lvbiwgY29weSB0aGUKZnNjYWNoZSBw
b2ludGVyIGZyb20gdGhlIHByaW1hcnkgY2hhbm5lbC4gVGhlIHByaW1hcnkKY2hhbm5lbCBpcyBn
dWFyYW50ZWVkIG5vdCB0byBnbyBhd2F5IGFzIGxvbmcgYXMgc2Vjb25kYXJ5CmNoYW5uZWxzIGFy
ZSBpbiB1c2UuICBBbHNvIGFkZHJlc3NlcyBtaW5vciBwcm9ibGVtIGZvdW5kCmJ5IGtlcm5lbCB0
ZXN0IHJvYm90LgoKUmVwb3J0ZWQtYnk6IGtlcm5lbCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwuY29t
PgpTaWduZWQtb2ZmLWJ5OiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29tPgpS
ZXZpZXdlZC1ieTogUGF1bG8gQWxjYW50YXJhIChTVVNFKSA8cGNAY2pyLm56PgpTaWduZWQtb2Zm
LWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9j
b25uZWN0LmMgfCAgNCArKysrCiBmcy9jaWZzL2ZzY2FjaGUuYyB8IDEwICsrKysrKysrKysKIDIg
ZmlsZXMgY2hhbmdlZCwgMTQgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29u
bmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXggN2NjNDY5ZTQ2ODJhLi4xODQ0OGRiZDc2
MmEgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5jCisrKyBiL2ZzL2NpZnMvY29ubmVjdC5j
CkBAIC0xNTYyLDYgKzE1NjIsMTAgQEAgY2lmc19nZXRfdGNwX3Nlc3Npb24oc3RydWN0IHNtYjNf
ZnNfY29udGV4dCAqY3R4LAogCS8qIGZzY2FjaGUgc2VydmVyIGNvb2tpZXMgYXJlIGJhc2VkIG9u
IHByaW1hcnkgY2hhbm5lbCBvbmx5ICovCiAJaWYgKCFDSUZTX1NFUlZFUl9JU19DSEFOKHRjcF9z
ZXMpKQogCQljaWZzX2ZzY2FjaGVfZ2V0X2NsaWVudF9jb29raWUodGNwX3Nlcyk7CisjaWZkZWYg
Q09ORklHX0NJRlNfRlNDQUNIRQorCWVsc2UKKwkJdGNwX3Nlcy0+ZnNjYWNoZSA9IHRjcF9zZXMt
PnByaW1hcnlfc2VydmVyLT5mc2NhY2hlOworI2VuZGlmIC8qIENPTkZJR19DSUZTX0ZTQ0FDSEUg
Ki8KIAogCS8qIHF1ZXVlIGVjaG8gcmVxdWVzdCBkZWxheWVkIHdvcmsgKi8KIAlxdWV1ZV9kZWxh
eWVkX3dvcmsoY2lmc2lvZF93cSwgJnRjcF9zZXMtPmVjaG8sIHRjcF9zZXMtPmVjaG9faW50ZXJ2
YWwpOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9mc2NhY2hlLmMgYi9mcy9jaWZzL2ZzY2FjaGUuYwpp
bmRleCBmNGRhNjkzNzYwYzEuLjFkYjM0MzdmM2I3ZCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9mc2Nh
Y2hlLmMKKysrIGIvZnMvY2lmcy9mc2NhY2hlLmMKQEAgLTI0LDYgKzI0LDcgQEAgc3RydWN0IGNp
ZnNfc2VydmVyX2tleSB7CiAJCXN0cnVjdCBpbl9hZGRyCWlwdjRfYWRkcjsKIAkJc3RydWN0IGlu
Nl9hZGRyCWlwdjZfYWRkcjsKIAl9OworCV9fdTY0IGNvbm5faWQ7CiB9IF9fcGFja2VkOwogCiAv
KgpAQCAtMzcsNiArMzgsMTQgQEAgdm9pZCBjaWZzX2ZzY2FjaGVfZ2V0X2NsaWVudF9jb29raWUo
c3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQogCXN0cnVjdCBjaWZzX3NlcnZlcl9rZXkg
a2V5OwogCXVpbnQxNl90IGtleV9sZW4gPSBzaXplb2Yoa2V5Lmhkcik7CiAKKwkvKgorCSAqIENo
ZWNrIGlmIGNvb2tpZSB3YXMgYWxyZWFkeSBpbml0aWFsaXplZCBzbyBkb24ndCByZWluaXRpYWxp
emUgaXQuCisJICogSW4gdGhlIGZ1dHVyZSwgYXMgd2UgaW50ZWdyYXRlIHdpdGggbmV3ZXIgZnNj
YWNoZSBmZWF0dXJlcywKKwkgKiB3ZSBtYXkgd2FudCB0byBpbnN0ZWFkIGFkZCBhIGNoZWNrIGlm
IGNvb2tpZSBoYXMgY2hhbmdlZAorCSAqLworCWlmIChzZXJ2ZXItPmZzY2FjaGUpCisJCXJldHVy
bjsKKwogCW1lbXNldCgma2V5LCAwLCBzaXplb2Yoa2V5KSk7CiAKIAkvKgpAQCAtNjIsNiArNzEs
NyBAQCB2b2lkIGNpZnNfZnNjYWNoZV9nZXRfY2xpZW50X2Nvb2tpZShzdHJ1Y3QgVENQX1NlcnZl
cl9JbmZvICpzZXJ2ZXIpCiAJCXNlcnZlci0+ZnNjYWNoZSA9IE5VTEw7CiAJCXJldHVybjsKIAl9
CisJa2V5LmNvbm5faWQgPSBzZXJ2ZXItPmNvbm5faWQ7CiAKIAlzZXJ2ZXItPmZzY2FjaGUgPQog
CQlmc2NhY2hlX2FjcXVpcmVfY29va2llKGNpZnNfZnNjYWNoZV9uZXRmcy5wcmltYXJ5X2luZGV4
LAotLSAKMi4zMi4wCgo=
--0000000000008c60f705d24241c8--
