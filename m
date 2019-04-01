Return-Path: <SRS0=XjJ0=SD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E688C43381
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Apr 2019 19:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C76A2084B
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Apr 2019 19:24:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZWMfx2PY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbfDATYM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Apr 2019 15:24:12 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45755 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfDATYM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Apr 2019 15:24:12 -0400
Received: by mail-lj1-f194.google.com with SMTP id y6so9259695ljd.12;
        Mon, 01 Apr 2019 12:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zfDAYxMUdVnYjJp+Dx14RhMDDgFeHzagKTbXB9mb5ko=;
        b=ZWMfx2PYYqNEXAIx5nBa3LBi44RiuqRsnTR3ZK0GsFm8L57ndgVynUIeLM7JOURbKR
         Q6EuHs/oZ4knET5+FtLDvuxKv8O6Ig57XwHYMkPBgMlhh3VWOV+LjnBWiPkuhI6qQUgj
         5lrWMxuMXcVhp3EprEDkVx77siZFQ35TT+Iy1omNiKUwUUx5KN9VkgKaJLrCWyjSWgY+
         W+yHN4oxRfM0QLTUO8FwfoeOjLFmT82okJfffRURy7i3mK4YArW6VgygJVB1h6KmU162
         RsUjpcYyKJk1Mvtj275vEbrA8nvRafzt+u47f1GogdJTFJCE5ztJ0Ac8dNTkWrqukEqr
         +Ekw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zfDAYxMUdVnYjJp+Dx14RhMDDgFeHzagKTbXB9mb5ko=;
        b=Cfo2T1yXXVaxuCODJ0ujU4bk7KzOp/szNJp+DvnR7p2Rm2ScEch/LqGcPGRX8Dt5ZC
         3+qwP9W+aAuDq5MTm7bodPutOKdzRIWoLtnOnGCm5oglfLwZbWicAA4ierWs4IOS/+Tm
         7EOO0nv/p2CIsAdmtKk2g7te9RsmvBVxsGNvw0PHl6WwkUjzWVskWJKlWiF6ZOJ1/Km3
         bzYiri26vri2qEiJAHe3924gtUZoT7vPfbEb+0mbmd1eSWHFUddnW5F3zTq24ZJirwI5
         NNmXZ88vh3zmb5PaUCRUUZ44W87JCzxHqcByqOGaSP1LyHhD2eQt/8jPK+weeI6CqJgm
         5WKg==
X-Gm-Message-State: APjAAAW3Veh9SZHMFcG/J1XS+6ZatGi1xVgwEgxbR6FgB+R6CxSnPTlK
        geqo390/yj4Ci2XLIsEOdxWJXPSClm4ld/fajw==
X-Google-Smtp-Source: APXvYqw5R57d8eg9R85HJvBfd0ko50dYtuoclhDMPn5GyL47lMxU/gqWhQVzuL+TWGLfaY3SrR7OGWBWVjEzBz++sFA=
X-Received: by 2002:a2e:8616:: with SMTP id a22mr36314892lji.173.1554146647551;
 Mon, 01 Apr 2019 12:24:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190401035417.13738-1-lsahlber@redhat.com> <20190401035417.13738-2-lsahlber@redhat.com>
 <CAH2r5mt4q=-tSr9T-2fJX7EBWpYMiCe5Xy8HKbRtDkmRdN2s_w@mail.gmail.com>
In-Reply-To: <CAH2r5mt4q=-tSr9T-2fJX7EBWpYMiCe5Xy8HKbRtDkmRdN2s_w@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 1 Apr 2019 12:23:53 -0700
Message-ID: <CAKywueQ8jDZGiAa8irA6xTQ773j=s2hmRt9qHsBtYcdSELE9hA@mail.gmail.com>
Subject: Re: [PATCH] secdesc-ui.py: a UI to view the security descriptors on
 SMB2+ shares
To:     Steve French <smfrench@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is really cool! Thanks Ronnie. I will be targeting this for the
next release of cifs-utils (not the one that I am about to cut off),
so we will have time to stabilize it.

Best regards,
Pavel Shilovsky

=D0=B2=D1=81, 31 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 21:51, Steve Frenc=
h via samba-technical
<samba-technical@lists.samba.org>:

>
> The tool that Ronnie proposed below looks useful (see below) and
> attached screenshot.  With this as a sample (along with 'smbinfo' tool
> in cifs-utils) and a starting point, those with python/GUI interest
> should be able to extend it in very interesting ways now that we have
> the ability to query server information much more broadly.  Managing
> ACLs, quotas, snapshots, alerts and many other fun features across
> such a broad set of servers (from Samba, to Windows, Azure and the
> Cloud, Macs, NetApp and various filers).
>
> Ronnie,
> Great idea.
>
> ---------- Forwarded message ---------
> From: Ronnie Sahlberg <lsahlber@redhat.com>
> Date: Sun, Mar 31, 2019 at 10:54 PM
> Subject: [PATCH] secdesc-ui.py: a UI to view the security descriptors
> on SMB2+ shares
> To: linux-cifs <linux-cifs@vger.kernel.org>
> Cc: Steve French <smfrench@gmail.com>, Pavel Shilovsky
> <pshilov@microsoft.com>, Ronnie Sahlberg <lsahlber@redhat.com>
>
> a simple python program with a basic UI to view the security descriptor
> for SMB2+ resources.
>
> With a basic starting point like this my hope is we can get some interest
> from people with python skills that may want to make it better until
> it becomes a full-fledged utility.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  secdesc-ui.py | 421 ++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 421 insertions(+)
>  create mode 100755 secdesc-ui.py
>
> diff --git a/secdesc-ui.py b/secdesc-ui.py
> new file mode 100755
> index 0000000..dcb9dbf
> --- /dev/null
> +++ b/secdesc-ui.py
> @@ -0,0 +1,421 @@
> +#!/usr/bin/env python
> +# coding: utf-8
> +
> +import array
> +import enum
> +import fcntl
> +import os
> +import struct
> +import stat
> +import sys
> +from Tkinter import *
> +
> +FULL_CONTROL =3D 0x001f01ff
> +EWRITE =3D 0x00000116
> +ALL_READ_BITS =3D 0x00020089
> +EREAD =3D 0x001200a9
> +CHANGE =3D 0x001301bf
> +
> +TRAV_EXEC =3D 0x00100020
> +LIST_READ =3D 0x00100001
> +READ_ATTR =3D 0x00100080
> +READ_XATT =3D 0x00100008
> +CREA_WRIT =3D 0x00100002
> +CREA_APPE =3D 0x00100004
> +WRIT_ATTR =3D 0x00100100
> +WRIT_XATT =3D 0x00100010
> +DELE =3D 0x00110000
> +READ_PERM =3D 0x00120000
> +CHAN_PERM =3D 0x00140000
> +TAKE_OWNR =3D 0x00180000
> +
> +class App:
> +       def __init__(self, root, sd, is_dir):
> +               self.sd =3D sd
> +                self.is_dir =3D is_dir
> +               self.tf =3D Frame(bd=3D1)
> +               self.tf.grid(columnspan=3D5, rowspan=3D5, padx=3D5, pady=
=3D5)
> +
> +               # Owner
> +               Label(self.tf, text=3D'Owner: %s' %
> (self.sd.owner)).grid(row=3D0, column=3D0, columnspan=3D6, sticky=3D'W')
> +
> +               # Group
> +               Label(self.tf, text=3D'Group: %s' %
> (self.sd.group)).grid(row=3D1, column=3D0, columnspan=3D6, sticky=3D'W')
> +
> +               self.sb =3D Scrollbar(self.tf, orient=3DVERTICAL)
> +               self.lb =3D Listbox(self.tf, height=3D5, selectmode=3DSIN=
GLE,
> +                               yscrollcommand=3Dself.sb.set)
> +               self.sb.config(command=3Dself.lb.yview)
> +               self.sb.grid(row=3D2, column=3D1, sticky=3D'NS')
> +               self.lb.grid(row=3D2, column=3D0, sticky=3D'W')
> +
> +                max =3D 0
> +               for idx, item in enumerate(self.sd.dacl.ace):
> +                       if item.type !=3D 0 and item.type !=3D 1:
> +                               continue
> +                        sid =3D '%s %s' % ("ALLOW" if item.type =3D=3D 0
> else "DENY", item.sid)
> +                        if max > len(sid):
> +                                max =3D len(sid)
> +                       self.lb.insert(idx, sid)
> +                       if not self.lb.curselection():
> +                               self.lb.selection_set(idx)
> +                self.lb.config(width=3Dmax)
> +                self.lb.bind("<Double-Button-1>", self.select_sid)
> +
> +               self.bas =3D Button(self.tf, text=3D'Basic', relief=3DSUN=
KEN,
> +                       command=3Dself.click_bas)
> +               self.bas.grid(row=3D2, column=3D2, sticky=3D'NW')
> +
> +               self.adv =3D Button(self.tf, text=3D'Advanced',
> +                       command=3Dself.click_adv)
> +               self.adv.grid(row=3D2, column=3D3, sticky=3D'NW')
> +
> +               # Basic Panel
> +               self.bf_bas =3D Frame(master=3Dself.tf, bd=3D1)
> +               self.bf_bas.grid(row=3D3, column=3D0, columnspan=3D4, pad=
x=3D5, pady=3D5)
> +               self.bf_bas_name =3D Label(self.bf_bas, text=3D'')
> +               self.bf_bas_name.grid(row=3D0, column=3D0, columnspan=3D2=
, sticky=3D'W')
> +
> +                row =3D 1
> +               self.bf_bas_fc=3DCheckbutton(self.bf_bas, text=3D'Full Co=
ntrol')
> +               self.bf_bas_fc.grid(row=3Drow, column=3D0, sticky=3D'W')
> +               self.bf_bas_fc.config(state=3DDISABLED)
> +                row +=3D 1
> +
> +               self.bf_bas_mo=3DCheckbutton(self.bf_bas, text=3D'Modify'=
)
> +               self.bf_bas_mo.grid(row=3Drow, column=3D0, sticky=3D'W')
> +               self.bf_bas_mo.config(state=3DDISABLED)
> +                row +=3D 1
> +
> +               self.bf_bas_re=3DCheckbutton(self.bf_bas, text=3D'Read & =
Execute')
> +               self.bf_bas_re.grid(row=3Drow, column=3D0, sticky=3D'W')
> +               self.bf_bas_re.config(state=3DDISABLED)
> +                row +=3D 1
> +
> +               self.bf_bas_rd=3DCheckbutton(self.bf_bas, text=3D'Read')
> +               self.bf_bas_rd.grid(row=3Drow, column=3D0, sticky=3D'W')
> +               self.bf_bas_rd.config(state=3DDISABLED)
> +                row +=3D 1
> +
> +               self.bf_bas_wr=3DCheckbutton(self.bf_bas, text=3D'Write')
> +               self.bf_bas_wr.grid(row=3Drow, column=3D0, sticky=3D'W')
> +               self.bf_bas_wr.config(state=3DDISABLED)
> +                row +=3D 1
> +
> +               self.bf_bas_sp=3DCheckbutton(self.bf_bas, text=3D'Special=
')
> +               self.bf_bas_sp.grid(row=3Drow, column=3D0, sticky=3D'W')
> +               self.bf_bas_sp.config(state=3DDISABLED)
> +                row +=3D 1
> +
> +               self.show_bas =3D True
> +               self.update_bf_bas()
> +
> +               # Advanced Panel
> +               self.bf_adv =3D Frame(master=3Dself.tf, bd=3D1)
> +               self.bf_adv.grid(row=3D3, column=3D0, columnspan=3D4, pad=
x=3D5, pady=3D5)
> +               self.bf_adv_name =3D Label(self.bf_adv, text=3D'')
> +               self.bf_adv_name.grid(row=3D0, column=3D0, columnspan=3D2=
, sticky=3D'W')
> +
> +                row =3D 1
> +               self.bf_adv_fc=3DCheckbutton(self.bf_adv, text=3D'Full Co=
ntrol')
> +               self.bf_adv_fc.grid(row=3Drow, column=3D0, sticky=3D'W')
> +               self.bf_adv_fc.config(state=3DDISABLED)
> +                row +=3D 1
> +
> +               self.bf_adv_te=3DCheckbutton(self.bf_adv,
> text=3D'Traverse-folder/execute-file')
> +               self.bf_adv_te.grid(row=3Drow, column=3D0, sticky=3D'W')
> +               self.bf_adv_te.config(state=3DDISABLED)
> +                row +=3D 1
> +
> +               self.bf_adv_lr=3DCheckbutton(self.bf_adv,
> text=3D'List-folder/read-data')
> +               self.bf_adv_lr.grid(row=3Drow, column=3D0, sticky=3D'W')
> +               self.bf_adv_lr.config(state=3DDISABLED)
> +                row +=3D 1
> +
> +               self.bf_adv_ra=3DCheckbutton(self.bf_adv, text=3D'Read-At=
tributes')
> +               self.bf_adv_ra.grid(row=3Drow, column=3D0, sticky=3D'W')
> +               self.bf_adv_ra.config(state=3DDISABLED)
> +                row +=3D 1
> +
> +               self.bf_adv_re=3DCheckbutton(self.bf_adv,
> text=3D'Read-Extended-Attributes')
> +               self.bf_adv_re.grid(row=3Drow, column=3D0, sticky=3D'W')
> +               self.bf_adv_re.config(state=3DDISABLED)
> +                row +=3D 1
> +
> +               self.bf_adv_cw=3DCheckbutton(self.bf_adv,
> text=3D'Create-files/write-data')
> +               self.bf_adv_cw.grid(row=3Drow, column=3D0, sticky=3D'W')
> +               self.bf_adv_cw.config(state=3DDISABLED)
> +                row +=3D 1
> +
> +               self.bf_adv_ca=3DCheckbutton(self.bf_adv,
> text=3D'Create-folders/append-data')
> +               self.bf_adv_ca.grid(row=3Drow, column=3D0, sticky=3D'W')
> +               self.bf_adv_ca.config(state=3DDISABLED)
> +                row +=3D 1
> +
> +                row =3D 1
> +               self.bf_adv_wa=3DCheckbutton(self.bf_adv, text=3D'Write-A=
ttributes')
> +               self.bf_adv_wa.grid(row=3Drow, column=3D1, sticky=3D'W')
> +               self.bf_adv_wa.config(state=3DDISABLED)
> +                row +=3D 1
> +
> +               self.bf_adv_we=3DCheckbutton(self.bf_adv,
> text=3D'Write-Extended-Attributes')
> +               self.bf_adv_we.grid(row=3Drow, column=3D1, sticky=3D'W')
> +               self.bf_adv_we.config(state=3DDISABLED)
> +                row +=3D 1
> +
> +               self.bf_adv_de=3DCheckbutton(self.bf_adv, text=3D'Delete'=
)
> +               self.bf_adv_de.grid(row=3Drow, column=3D1, sticky=3D'W')
> +               self.bf_adv_de.config(state=3DDISABLED)
> +                row +=3D 1
> +
> +               self.bf_adv_rp=3DCheckbutton(self.bf_adv, text=3D'Read-Pe=
rmissions')
> +               self.bf_adv_rp.grid(row=3Drow, column=3D1, sticky=3D'W')
> +               self.bf_adv_rp.config(state=3DDISABLED)
> +                row +=3D 1
> +
> +               self.bf_adv_cp=3DCheckbutton(self.bf_adv,
> text=3D'Change-Permissions')
> +               self.bf_adv_cp.grid(row=3Drow, column=3D1, sticky=3D'W')
> +               self.bf_adv_cp.config(state=3DDISABLED)
> +                row +=3D 1
> +
> +               self.bf_adv_to=3DCheckbutton(self.bf_adv, text=3D'Take-Ow=
nership')
> +               self.bf_adv_to.grid(row=3Drow, column=3D1, sticky=3D'W')
> +               self.bf_adv_to.config(state=3DDISABLED)
> +                row +=3D 1
> +
> +               self.bf_adv.grid_remove()
> +
> +       def select_sid(self, event):
> +                self.click_bas()
> +
> +       def click_bas(self):
> +               self.adv.config(relief=3DRAISED)
> +               self.bas.config(relief=3DSUNKEN)
> +               self.bf_adv.grid_remove()
> +               self.update_bf_bas()
> +               self.bf_bas.grid()
> +               self.show_bas =3D True
> +
> +       def click_adv(self):
> +               self.adv.config(relief=3DSUNKEN)
> +               self.bas.config(relief=3DRAISED)
> +               self.bf_bas.grid_remove()
> +               self.update_bf_adv()
> +               self.bf_adv.grid()
> +               self.show_bas =3D False
> +
> +       def update_bf_adv(self):
> +               ace =3D self.sd.dacl.ace[self.lb.curselection()[0]]
> +               self.bf_adv_name.config(text=3D'Advanced Permissions for
> %s' % (ace.sid))
> +               if ace.mask =3D=3D FULL_CONTROL:
> +                       self.bf_adv_fc.select()
> +               else:
> +                       self.bf_adv_fc.deselect()
> +               if ace.mask & TRAV_EXEC =3D=3D TRAV_EXEC:
> +                       self.bf_adv_te.select()
> +               else:
> +                       self.bf_adv_te.deselect()
> +               if ace.mask & LIST_READ =3D=3D LIST_READ:
> +                       self.bf_adv_lr.select()
> +               else:
> +                       self.bf_adv_lr.deselect()
> +               if ace.mask & READ_ATTR =3D=3D READ_ATTR:
> +                       self.bf_adv_ra.select()
> +               else:
> +                       self.bf_adv_ra.deselect()
> +               if ace.mask & READ_XATT =3D=3D READ_XATT:
> +                       self.bf_adv_re.select()
> +               else:
> +                       self.bf_adv_re.deselect()
> +               if ace.mask & CREA_WRIT =3D=3D CREA_WRIT:
> +                       self.bf_adv_cw.select()
> +               else:
> +                       self.bf_adv_cw.deselect()
> +               if ace.mask & CREA_APPE =3D=3D CREA_APPE:
> +                       self.bf_adv_ca.select()
> +               else:
> +                       self.bf_adv_ca.deselect()
> +               if ace.mask & WRIT_ATTR =3D=3D WRIT_ATTR:
> +                       self.bf_adv_wa.select()
> +               else:
> +                       self.bf_adv_wa.deselect()
> +               if ace.mask & WRIT_XATT =3D=3D WRIT_XATT:
> +                       self.bf_adv_we.select()
> +               else:
> +                       self.bf_adv_we.deselect()
> +               if ace.mask & DELE =3D=3D DELE:
> +                       self.bf_adv_de.select()
> +               else:
> +                       self.bf_adv_de.deselect()
> +               if ace.mask & READ_PERM =3D=3D READ_PERM:
> +                       self.bf_adv_rp.select()
> +               else:
> +                       self.bf_adv_rp.deselect()
> +               if ace.mask & CHAN_PERM =3D=3D CHAN_PERM:
> +                       self.bf_adv_rp.select()
> +               else:
> +                       self.bf_adv_rp.deselect()
> +               if ace.mask & TAKE_OWNR =3D=3D TAKE_OWNR:
> +                       self.bf_adv_to.select()
> +               else:
> +                       self.bf_adv_to.deselect()
> +
> +       def update_bf_bas(self):
> +               ace =3D self.sd.dacl.ace[self.lb.curselection()[0]]
> +               self.bf_bas_name.config(text=3D'Permissions for %s' % (ac=
e.sid))
> +               tmp =3D ace.mask
> +               if ace.mask =3D=3D FULL_CONTROL:
> +                       self.bf_bas_fc.select()
> +                       tmp &=3D ~FULL_CONTROL
> +               else:
> +                       self.bf_bas_fc.deselect()
> +               if ace.mask & CHANGE =3D=3D CHANGE:
> +                       self.bf_bas_mo.select()
> +                       tmp &=3D ~CHANGE
> +               else:
> +                       self.bf_bas_mo.deselect()
> +               if ace.mask & EREAD =3D=3D EREAD:
> +                       self.bf_bas_re.select()
> +                       tmp &=3D ~EREAD
> +               else:
> +                       self.bf_bas_re.deselect()
> +               if ace.mask & ALL_READ_BITS =3D=3D ALL_READ_BITS:
> +                       self.bf_bas_rd.select()
> +                       tmp &=3D ~ALL_READ_BITS
> +               else:
> +                       self.bf_bas_rd.deselect()
> +               if ace.mask & EWRITE =3D=3D EWRITE:
> +                       self.bf_bas_wr.select()
> +                       tmp &=3D ~EWRITE
> +               else:
> +                       self.bf_bas_wr.deselect()
> +               if tmp:
> +                       self.bf_bas_sp.select()
> +               else:
> +                       self.bf_bas_sp.deselect()
> +
> +CIFS_QUERY_INFO =3D 0xc018cf07
> +
> +def usage():
> +        print "Usage: %s <filename>" % (sys.argv[0])
> +        sys.exit()
> +
> +class SID:
> +        def __init__(self, buf):
> +                self.sub_authority_count =3D buf[1]
> +                self.buffer =3D buf[:8 + self.sub_authority_count * 4]
> +                self.revision =3D self.buffer[0]
> +                if self.revision !=3D 1:
> +                        raise ValueError('SID Revision %d not supported'=
 %
> +                                         (self.revision))
> +                self.identifier_authority =3D 0
> +                for x in self.buffer[2:8]:
> +                        self.identifier_authority =3D
> self.identifier_authority * 256 + x
> +                self.sub_authority =3D []
> +                for i in range(self.sub_authority_count):
> +
> self.sub_authority.append(struct.unpack_from('<I', self.buffer, 8 + 4
> * i)[0])
> +
> +        def __str__(self):
> +                s =3D "S-%u-%u" % (self.revision, self.identifier_author=
ity)
> +
> +                for x in self.sub_authority:
> +                        s +=3D '-%u' % x
> +                return s
> +
> +
> +class ACE:
> +        def __init__(self, buf):
> +                self.type =3D buf[0]
> +                self.flags =3D buf[1]
> +                self.size =3D struct.unpack_from('<H', buf, 2)[0]
> +                self.raw =3D buf[:self.size]
> +                if self.type in [0, 1]:
> +                        self.mask =3D struct.unpack_from('<I', buf, 4)[0=
]
> +                        self.sid =3D SID(buf[8:])
> +
> +        def __str__(self):
> +                s =3D 'Type:0x%02x ' % (self.type)
> +                s +=3D 'Flags:0x%02x ' % (self.flags)
> +                if self.type in [0, 1]:
> +                        s +=3D 'Mask:0x%02x SID:%s' % (self.mask, self.s=
id)
> +                else:
> +                        for i in self.raw[4:]:
> +                                s +=3D '%02x' % (i)
> +
> +                return s
> +
> +        class Type(enum.Enum):
> +                ALLOWED =3D 0
> +                DENIED =3D 1
> +
> +                def __str__(self):
> +                        return self.name
> +
> +class ACL:
> +        def __init__(self, buf):
> +                self.revision =3D buf[0]
> +                if self.revision !=3D 2 and self.revision !=3D 4:
> +                        raise ValueError('ACL Revision %d '
> +                                         'not supported' % (self.revisio=
n))
> +                acl =3D buf[8:8 + struct.unpack_from('<H', buf, 2)[0]]
> +                self.ace =3D []
> +                for i in range(struct.unpack_from('<H', buf, 4)[0]):
> +                        ace =3D ACE(acl)
> +                        self.ace.append(ace)
> +                        acl =3D acl[ace.size:]
> +
> +        def __str__(self):
> +                s =3D 'Revision:0x%02x\n' % (self.revision)
> +                for ace in self.ace:
> +                        s +=3D '%s\n' % (ace)
> +                return s
> +
> +class SecurityDescriptor:
> +        def __init__(self, buf):
> +                self.revision =3D buf[0]
> +                if self.revision !=3D 1:
> +                        raise ValueError('Security Descriptor Revision %=
d '
> +                                         'not supported' % (self.revisio=
n))
> +                self.control =3D struct.unpack_from('<H', buf, 2)
> +
> +                self.owner =3D SID(buf[struct.unpack_from('<I', buf, 4)[=
0]:])
> +                self.group =3D SID(buf[struct.unpack_from('<I', buf, 8)[=
0]:])
> +
> +                self.dacl =3D ACL(buf[struct.unpack_from('<I', buf, 16)[=
0]:])
> +
> +        def __str__(self):
> +                s =3D 'Revision:%u\n' % (self.revision)
> +                s +=3D 'Control:0x%04x\n' % (self.control)
> +                s +=3D 'Owner:%s\n' % (self.owner)
> +                s +=3D 'Group:%s\n' % (self.group)
> +                s +=3D 'DACL:\n%s' % (self.dacl)
> +                return s
> +
> +def main():
> +        if len(sys.argv) !=3D 2:
> +                usage()
> +
> +        buf =3D array.array('B', [0] * 16384)
> +
> +        struct.pack_into('<I', buf, 0, 3) # InfoType: Security
> +        struct.pack_into('<I', buf, 8, 7) # AddInfo: Group/Owner/Dacl
> +        struct.pack_into('<I', buf, 16, 16384) # InputBufferLength
> +
> +        #with open(sys.argv[1], 'r') as f:
> +        f =3D os.open(sys.argv[1], os.O_RDONLY)
> +        st =3D os.fstat(f)
> +        fcntl.ioctl(f, CIFS_QUERY_INFO, buf, 1)
> +       os.close(f)
> +
> +        s =3D struct.unpack_from('<I', buf, 16)
> +
> +        sd =3D SecurityDescriptor(buf[24:24 + s[0]])
> +
> +        root =3D Tk()
> +        app =3D App(root, sd, stat.S_ISDIR(st.st_mode))
> +        root.mainloop()
> +
> +
> +if __name__ =3D=3D "__main__":
> +       main()
> +
> --
> 2.13.6
>
>
>
> --
> Thanks,
>
> Steve
