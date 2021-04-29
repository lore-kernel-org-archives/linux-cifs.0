Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB5C5C433ED
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Apr 2021 15:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96FD66144B
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Apr 2021 15:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbhD2Psy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Apr 2021 11:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbhD2Psx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Apr 2021 11:48:53 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BCDC06138B
        for <linux-cifs@vger.kernel.org>; Thu, 29 Apr 2021 08:48:07 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id p126so25449264yba.1
        for <linux-cifs@vger.kernel.org>; Thu, 29 Apr 2021 08:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DC9OUrYL3WDCaPq472Qe5zfbDHEGbSrIfnluzKVsooI=;
        b=gw6ZeQ48qV5qz/6XkWKFBHJDu617pqPqperHemIu3imv3KRhxM1JkWmkVweccLTpak
         Q5NLMgA2OQQOCXYjt2oIcsXXfXIB/tQzWKvtodELNatwd+zojS8Bu5e7auk+/185NkLF
         Yi6nj3nONsDlNkpfZcGEDtny0h8gpezgpF1+YHJnRbuBsjEKU9wOd4EfIVDDEZKp/KEA
         iXM/rwaz8K140dT+69wA5d5x2buMqzEkccMrmrH2Wxr+z0qqcdByK9UYTJyvttbjvaUg
         +qU0eo+2gK3c6seZogDFC/2dmxm3MeXC3ZgIOA4kXkfE90AX7wCZuGGsbeWtFGFWCy+J
         m9kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DC9OUrYL3WDCaPq472Qe5zfbDHEGbSrIfnluzKVsooI=;
        b=ZDfbPCTzD3CHxMc/a9JuR1ORz7NsLfPmDDrSaRUUTznpmxvo0YshRgG3+ulwA0wOXn
         Ax5AihwaRDV4Zp+MqZwetlE94fEpE43j3xTatJjhMFI6sGdAgpvfxxcZ8ceA4w97uvCF
         FLqgbr892bpgDpTA21Aao6Ne76AoBV/7yOwWS/zNdjJwrPCYJEe4kyDJUA0HrEt0d8Kq
         3K2bKFTeywpKmnHIL/SpGX/HY6gJXlcnP38wQzB4lzf09enxz5mdGz8k1CVjlx13XAs8
         FNJc6mE5+NecMtlSNaM0/3ZW41qwhb6Nh2W0WPZDoV917xjwN9iXask+toUnUc3GeQ+W
         a5GA==
X-Gm-Message-State: AOAM532uhKM9KghvWF4KA8jdTECedNdFmJNU5/Z0GVKFPXPHPSInbbDm
        zjo37wtrpQ6+xB98LAwovr1gVjYKbPqLDoaoqFzr20VbUiM=
X-Google-Smtp-Source: ABdhPJxSX1Xg2L0O5QZO8GbP1AN9n9VTxmIYTIDAXQjyW2tdJ9Tx05bLcvvey5z+MRPkgw54cnbEexLXcp07evM4ddo=
X-Received: by 2002:a25:7085:: with SMTP id l127mr168387ybc.293.1619711286293;
 Thu, 29 Apr 2021 08:48:06 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=qykPGoWwtfSdXe9BsXp083M9-7zaAXJgkPok0Onp6Zow@mail.gmail.com>
 <87zgxhuxdd.fsf@suse.com> <CANT5p=ojeaoyifJ-6bxc0mGnAnYqgUH5=W8exhjf=8Hjfat5Eg@mail.gmail.com>
In-Reply-To: <CANT5p=ojeaoyifJ-6bxc0mGnAnYqgUH5=W8exhjf=8Hjfat5Eg@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 29 Apr 2021 21:17:55 +0530
Message-ID: <CANT5p=oeCf3VeyFECPeUrnGwQM71pehj=o0t25z-+hWmpY+bSg@mail.gmail.com>
Subject: Re: [PATCH] cifs: detect dead connections only when echoes are enabled.
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000dbe9c305c11e6b14"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000dbe9c305c11e6b14
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Attaching updated patch with can_echo() instead of referencing echoes direc=
tly.
I'll submit another patch for the other changes.

Regards,
Shyam

On Thu, Apr 29, 2021 at 5:59 PM Shyam Prasad N <nspmangalore@gmail.com> wro=
te:
>
> Hi Aur=C3=A9lien,
>
> Replies below...
>
> On Thu, Apr 29, 2021 at 5:16 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wro=
te:
> >
> >
> > Hi Shyam,
> >
> > Ok so I ended up looking at a lot of code to check this... And I'm stil=
l
> > unsure.
> >
> > First, it looks like server->echoes is only used for smb2 and there is
> > a generic server->ops->can_echo() you can use that just returns
> > server->echoes it for smb2.
> Agree. I can use can_echo() instead.
>
> >
> > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > Hi,
> > >
> > > Recently, some xfstests and later some manual testing on multi-channe=
l
> > > revealed that we detect unresponsive servers on some of the channels
> > > to the same server.
> > >
> > > The issue is seen when a channel is setup and sits idle without any
> > > traffic. Generally, we enable echoes and oplocks on a channel during
> > > the first request, based on the number of credits available on the
> > > channel. So on idle channels, we trip in our logic to check server
> > > unresponsiveness.
> >
> > That makes sense but while looking at the code I see we always queue
> > echo request in cifs_get_tcp_session(), which is called when adding a
> > channel.
> >
> > cifs_ses_add_channel() {
> >         ctx.echo_interval =3D ses->server->echo_interval / HZ;
> >
> >         chan->server =3D cifs_get_tcp_session(&ctx);
> >
> >         rc =3D cifs_negotiate_protocol(xid, ses) {
> >                 server->tcpStatus =3D CifsGood;
> >         }
> >
> >         rc =3D cifs_setup_session(xid, ses, cifs_sb->local_nls);
> > }
> >
> > cifs_get_tcp_session() {
> >
> >         INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
> >
> >         tcp_ses->tcpStatus =3D CifsNeedNegotiate;
> >
> >         tcp_ses->lstrp =3D jiffies;
> >
> >         if (ctx->echo_interval >=3D SMB_ECHO_INTERVAL_MIN &&
> >                 ctx->echo_interval <=3D SMB_ECHO_INTERVAL_MAX)
> >                 tcp_ses->echo_interval =3D ctx->echo_interval * HZ;
> >         else
> >                 tcp_ses->echo_interval =3D SMB_ECHO_INTERVAL_DEFAULT * =
HZ;
> >
> >         queue_delayed_work(cifsiod_wq, &tcp_ses->echo, tcp_ses->echo_in=
terval);
> > }
> >
> > cifs_echo_request() {
> >
> >         if (server->tcpStatus =3D=3D CifsNeedNegotiate)
> >                 echo_interval =3D 0; <=3D=3D=3D branch taken
> >         else
> >                 echo_interval =3D server->echo_interval;
> >
> >         if (server->tcpStatus not in {NeedReconnect, Exiting, New}
> >            && server->can_echo()
> >            && jiffies > server->lstrp + echo_interval - HZ)
> >         {
> >                 server->echo();
> >         }
> >
> >         queue_delayed_work(cifsiod_wq, &server->echo, server->echo_inte=
rval);
> >         =3D=3D=3D> echo_interval =3D 0 so calls itself immediatly
> > }
> >
> > SMB2_echo() {
> >         if (server->tcpStatus =3D=3D CifsNeedNegotiate) {
> >                 /* No need to send echo on newly established connection=
s */
> >                 mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
> >                 =3D=3D=3D=3D> calls smb2_reconnect_server() immediatly =
if NeedNego
> >                 return rc;
> >         }
> >
> > }
> >
> > smb2_reconnect_server() {
> >         // channel has no TCONs so it does essentially nothing
> > }
> >
> > server_unresponsive() {
> >         if (server->tcpStatus in {Good, NeedNegotiate}
> >            && jiffies > server->lstrp + 3 * server->echo_interval)
> >         {
> >                 cifs_server_dbg(VFS, "has not responded in %lu seconds.=
 Reconnecting...\n",
> >                          (3 * server->echo_interval) / HZ);
> >                 cifs_reconnect(server);
> >                 return true;
> >         }
> >         return false;
> > }
> >
> > So it looks to me that cifs_get_tcp_session() starts the
> > cifs_echo_request() work, which calls itself with no delay in an
> > infinite loop doing nothing (that's probably bad...) until session_setu=
p
> > succeeds, after which the delay between the self-call is set.
>
> Perhaps we think that 1 sec is too much for us to complete negotiate?
> But echo_interval of 0 looks bad.
>
> Ideally, we should queue echo work only when session setup is complete.
> What do you think?
>
> >
> > During session_setup():
> >
> > * last response time (lstrp) gets updated
> >
> > * sending/recv requests should interact with the server
> >   credits and call change_conf(), which should enable server->echoes
> >   =3D=3D> is that part not working?
> It's working. But since these channels are idle, change_conf is not
> called for these channels.
> So echoes=3Dfalse till there's some activity on the channel.
>
> >
> > Once enabled, the echo_request workq will finally send the echo on the
> > wire, which should -/+ 1 credit and update lstrp.
> >
> > > Attached a one-line fix for this. Have tested it in my environment.
> > > Another approach to fix this could be to enable echoes during
> > > initialization of a server struct. Or soon after the session setup.
> > > But I felt that this approach is better. Let me know if you feel
> > > otherwise.
> >
> > I think the idea of your change is ok but there's probably also an issu=
e
> > in crediting in session_setup()/change_conf() if echoes is not enabled
> > at this point no?
> >
> > Cheers,
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnber=
g, DE
> > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)
> >
>
>
> --
> Regards,
> Shyam



--=20
Regards,
Shyam

--000000000000dbe9c305c11e6b14
Content-Type: application/octet-stream; 
	name="0001-cifs-detect-dead-connections-only-when-echoes-are-en.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-detect-dead-connections-only-when-echoes-are-en.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ko329rj10>
X-Attachment-Id: f_ko329rj10

RnJvbSA4YWVlYWQ2ZDUyMGExOTlhOGM0NGM5ZjNkZjMwZGRlNzI4MTBkZDEzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBUaHUsIDI5IEFwciAyMDIxIDA3OjUzOjE4ICswMDAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogZGV0ZWN0IGRlYWQgY29ubmVjdGlvbnMgb25seSB3aGVuIGVjaG9lcyBhcmUgZW5hYmxl
ZC4KCldlIGNhbiBkZXRlY3Qgc2VydmVyIHVucmVzcG9uc2l2ZW5lc3Mgb25seSBpZiBlY2hvZXMg
YXJlIGVuYWJsZWQuCkVjaG9lcyBjYW4gYmUgZGlzYWJsZWQgdW5kZXIgdHdvIHNjZW5hcmlvczoK
MS4gVGhlIGNvbm5lY3Rpb24gaXMgbG93IG9uIGNyZWRpdHMsIHNvIHdlJ3ZlIGRpc2FibGVkIGVj
aG9lcy9vcGxvY2tzLgoyLiBUaGUgY29ubmVjdGlvbiBoYXMgbm90IHNlZW4gYW55IHJlcXVlc3Qg
dGlsbCBub3cgKG90aGVyIHRoYW4KbmVnb3RpYXRlL3Nlc3Mtc2V0dXApLCB3aGljaCBpcyB3aGVu
IHdlIGVuYWJsZSB0aGVzZSB0d28sIGJhc2VkIG9uCnRoZSBjcmVkaXRzIGF2YWlsYWJsZS4KClNv
IHRoaXMgZml4IHdpbGwgY2hlY2sgZm9yIGRlYWQgY29ubmVjdGlvbiwgb25seSB3aGVuIGVjaG8g
aXMgZW5hYmxlZC4KClNpZ25lZC1vZmYtYnk6IFNoeWFtIFByYXNhZCBOIDxzcHJhc2FkQG1pY3Jv
c29mdC5jb20+Ci0tLQogZnMvY2lmcy9jb25uZWN0LmMgfCAxICsKIDEgZmlsZSBjaGFuZ2VkLCAx
IGluc2VydGlvbigrKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9j
b25uZWN0LmMKaW5kZXggMTIxZDhiNDUzNWIwLi5iZWNkNWY4MDc3ODcgMTAwNjQ0Ci0tLSBhL2Zz
L2NpZnMvY29ubmVjdC5jCisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC00NzYsNiArNDc2LDcg
QEAgc2VydmVyX3VucmVzcG9uc2l2ZShzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIpCiAJ
ICovCiAJaWYgKChzZXJ2ZXItPnRjcFN0YXR1cyA9PSBDaWZzR29vZCB8fAogCSAgICBzZXJ2ZXIt
PnRjcFN0YXR1cyA9PSBDaWZzTmVlZE5lZ290aWF0ZSkgJiYKKwkgICAgKCFzZXJ2ZXItPm9wcy0+
Y2FuX2VjaG8gfHwgc2VydmVyLT5vcHMtPmNhbl9lY2hvKHNlcnZlcikpICYmCiAJICAgIHRpbWVf
YWZ0ZXIoamlmZmllcywgc2VydmVyLT5sc3RycCArIDMgKiBzZXJ2ZXItPmVjaG9faW50ZXJ2YWwp
KSB7CiAJCWNpZnNfc2VydmVyX2RiZyhWRlMsICJoYXMgbm90IHJlc3BvbmRlZCBpbiAlbHUgc2Vj
b25kcy4gUmVjb25uZWN0aW5nLi4uXG4iLAogCQkJICgzICogc2VydmVyLT5lY2hvX2ludGVydmFs
KSAvIEhaKTsKLS0gCjIuMjUuMQoK
--000000000000dbe9c305c11e6b14--
