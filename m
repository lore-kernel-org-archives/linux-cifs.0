Return-Path: <SRS0=49Qs=SM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3613AC10F11
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Apr 2019 19:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5B192070D
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Apr 2019 19:33:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L5F6YGnJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbfDJTdR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Apr 2019 15:33:17 -0400
Received: from mail-lf1-f41.google.com ([209.85.167.41]:43989 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfDJTdR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Apr 2019 15:33:17 -0400
Received: by mail-lf1-f41.google.com with SMTP id g7so2701969lfh.10
        for <linux-cifs@vger.kernel.org>; Wed, 10 Apr 2019 12:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UEBX0734gIt8oH8P/8QRPIZN9oTDmPJAQHu2EA4j70M=;
        b=L5F6YGnJRWED1FV364Ys0G342qFe1AJ77PzODyFWRj1cQ/SBTEIEUeCvoH5Kok07JB
         fr5gF+JnXcIwHX1kMk12msXrMI2trh/GcgGdepHeXhlAm+2x4ZxO90Tt4a5o6J0x4mgY
         ZnqLTFPm06gs/8fndgOWTc+ZvZStmKkqmwgWQTLkjpzTwo0r77bYpQFJcRqgbsqPTQPG
         5Tc/LplajbxoJ3jt1I3zm0nhW/m61jSZtY81z3sG9NL95tX4tMnbCKC0uq+okPn1kIqR
         pAEa8z0KuWG7oKowif2T5RYn1f3g7Jkx+N02hCIXXKnkpFG/jSSBP4mV9PeCDOoWW3iD
         QYzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UEBX0734gIt8oH8P/8QRPIZN9oTDmPJAQHu2EA4j70M=;
        b=Yf/eyvfkPynLsBKOR1n9/JQP6fCYYkMBpelfztpMfL041WxEkvFpxgjrbIafjmiWdK
         pUc3s9yedsNJFfvYIX0khpfWmzKM8uXfoKevbL1wJbhQlErLz1X8ZgkUcsAvBSXW73bg
         6Xd8RxZ/7cUbqdR8kHWXwpeAh/HVSfDB0gyg0fE6pLUUiKoERGrLt3+jRk/xpXB3xcYL
         MFdUNW8YZyJ1p8GgF7GLmRCgqR+9YtQDCTMVYUB8oy0Eg1eAiu3rqBy2DLIPNJrVn91+
         14dO/ZyS30W3KP2gCiEWoS02nf9Z/Z8bfrEnTAqnkWTyrG1vIEn8OzKOLWSLTRmig0+E
         1jvw==
X-Gm-Message-State: APjAAAUD5w/b8zLb9hRf8o0fwFoNTGGzzBRjbHrGYqq2EKoRb2/4v9Pq
        6elTIi6940CA0CaNnW3zFkaIk0YLwk4BH4W1tQ==
X-Google-Smtp-Source: APXvYqxZCVC2peNJI3SMMXiSj7Ub/eQIc0Y4kPuwlM8vbaMSMIJHar4HfL0tpblk3E3Et5S8VZnh10+SCHxnOnowqeY=
X-Received: by 2002:ac2:4563:: with SMTP id k3mr23532342lfm.101.1554924794270;
 Wed, 10 Apr 2019 12:33:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190409023929.15098-1-lsahlber@redhat.com> <20190409023929.15098-2-lsahlber@redhat.com>
In-Reply-To: <20190409023929.15098-2-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 10 Apr 2019 12:33:02 -0700
Message-ID: <CAKywueRivv_i-c6TYi_-eWEsCvhFCw+DAzP=afpfH6EpxsJUhA@mail.gmail.com>
Subject: Re: [PATCH] secdesc-ui.py: a UI to view the security descriptors on
 SMB2+ shares
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 8 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 19:44, Ronnie Sahlb=
erg <lsahlber@redhat.com>:
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  secdesc-ui.py | 437 ++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 437 insertions(+)
>  create mode 100755 secdesc-ui.py
>
> diff --git a/secdesc-ui.py b/secdesc-ui.py
> new file mode 100755
> index 0000000..26db582
> --- /dev/null
> +++ b/secdesc-ui.py
> @@ -0,0 +1,437 @@
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
> +               Label(self.tf, text=3D'Owner: %s' % (self.sd.owner)).grid=
(row=3D0, column=3D0, columnspan=3D6, sticky=3D'W')
> +
> +               # Group
> +               Label(self.tf, text=3D'Group: %s' % (self.sd.group)).grid=
(row=3D1, column=3D0, columnspan=3D6, sticky=3D'W')
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
> +                        sid =3D '%s %s' % ("ALLOW" if item.type =3D=3D 0=
 else "DENY", item.sid)
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
> +               self.bf_adv_te=3DCheckbutton(self.bf_adv, text=3D'Travers=
e-folder/execute-file')
> +               self.bf_adv_te.grid(row=3Drow, column=3D0, sticky=3D'W')
> +               self.bf_adv_te.config(state=3DDISABLED)
> +                row +=3D 1
> +
> +               self.bf_adv_lr=3DCheckbutton(self.bf_adv, text=3D'List-fo=
lder/read-data')
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
> +               self.bf_adv_re=3DCheckbutton(self.bf_adv, text=3D'Read-Ex=
tended-Attributes')
> +               self.bf_adv_re.grid(row=3Drow, column=3D0, sticky=3D'W')
> +               self.bf_adv_re.config(state=3DDISABLED)
> +                row +=3D 1
> +
> +               self.bf_adv_cw=3DCheckbutton(self.bf_adv, text=3D'Create-=
files/write-data')
> +               self.bf_adv_cw.grid(row=3Drow, column=3D0, sticky=3D'W')
> +               self.bf_adv_cw.config(state=3DDISABLED)
> +                row +=3D 1
> +
> +               self.bf_adv_ca=3DCheckbutton(self.bf_adv, text=3D'Create-=
folders/append-data')
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
> +               self.bf_adv_we=3DCheckbutton(self.bf_adv, text=3D'Write-E=
xtended-Attributes')
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
> +               self.bf_adv_cp=3DCheckbutton(self.bf_adv, text=3D'Change-=
Permissions')
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
> +               self.bf_adv_name.config(text=3D'Advanced Permissions for =
%s' % (ace.sid))
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
> +
> +class SID:
> +        '''
> +        SID implements a Windows Security Identifier as per MS-DTYP:2.4.=
2.
> +        '''
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
> +                        self.identifier_authority =3D self.identifier_au=
thority * 256 + x
> +                self.sub_authority =3D []
> +                for i in range(self.sub_authority_count):
> +                        self.sub_authority.append(struct.unpack_from('<I=
', self.buffer, 8 + 4 * i)[0])
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
> +        '''
> +        ACE implements a Windows ACE as per MS-DTYP:2.4.4.
> +        '''
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
> +
> +class ACL:
> +        '''
> +        ACL implements a Windows ACL as per MS-DTYP:2.4.5.
> +        '''
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
> +
> +class SecurityDescriptor:
> +        '''
> +        SecurityDescriptor implements a Windows Security Descriptor as p=
er
> +        MS-DTYP:2.4.6.
> +        '''
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

Fixed minor code style problems and merged. Thanks.

https://github.com/piastry/cifs-utils/commit/0009157e9db4dc1f9f8ab66feebea2=
d7d12014b1

--
Best regards,
Pavel Shilovsky
