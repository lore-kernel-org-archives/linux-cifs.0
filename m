Return-Path: <SRS0=XjJ0=SD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DC_PNG_UNO_LARGO,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC305C43381
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Apr 2019 04:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5489E2086C
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Apr 2019 04:51:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vgh8oJ9M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfDAEve (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Apr 2019 00:51:34 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:34012 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbfDAEve (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Apr 2019 00:51:34 -0400
Received: by mail-pg1-f178.google.com with SMTP id v12so4112204pgq.1;
        Sun, 31 Mar 2019 21:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e4q3UnywIGlhN/60TnVC5Khr7Jhu98TCOxIdZG3osu8=;
        b=Vgh8oJ9MxkDXQrmCxGGnBtnHBcQfwm7a9ooKN46GgBpzHhRoHf6Tz8fcuP80f9eokC
         WntEc/FqWcyFJEPoP+5ik6kElSjkrMcs9xttTIh1s0QnAdVrsCSUjAfLaJpiXmjRf0Aw
         Q6+zhLx41aBGeO/RREOZf9Tn/YdmOR6ZcP0xTQ/qjv8R5E3xWvWtBc8JaUqqjD5bDfFA
         24ixSzxdHUWXtTEe4FIxaUIFGb56uQML2LZ5ajhouaUMKHQl+6rFqpEWDoLJns3MD8HQ
         IBn7+XwjOCGybpbEWelJEmXBWZof3CY/BwKIX4o6GgMsmNEbYmmu/1fMXvOKKHcrcW22
         iCEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e4q3UnywIGlhN/60TnVC5Khr7Jhu98TCOxIdZG3osu8=;
        b=SJyGVC6eDT+sObyf1R0Yd+3gaAI0sswNL3ff6JjGqSX+uHsVUL/9JDncleYUFQArue
         qX+PU4sS3vfhrW/Nxaf/CtbcgPax0i4yX4mdbV/6If3410/xCInayULwF5C8lSt/4O8M
         GyV0zOLztT7ICdKaory4QnVkDu6v95ubnOs7F8Jn1oVAinf4O7fEZFk7dTYh2CXdwf0h
         oFifVBvePEd4SWVIoHptlkFDSNuFJ/9gvkt0abl7VMnnkfoecyVh0ujUhoa26vTN90PH
         oiuxnbSmequlLBstwYOk4y+01kx+8uQJnqPfXCQ2ainjtKAzDNKF0zow34s6IYSMn3Uh
         FNGw==
X-Gm-Message-State: APjAAAXUmr3IEJqU/HEdJ10jjWB5BVgXxfcBqk3CrWhT/ozi8564RtgX
        nPutnIg6q496n8yDPYng+NxQxEY6aAGPNVIkk5M=
X-Google-Smtp-Source: APXvYqxRZFBIXhGFAQBkWO3j+1J6Bs2VFbglmHNX/7oDBEcTigTV6giSiduUkAYjVkQtgWBolOoZt3wZBhrFIkpW5vw=
X-Received: by 2002:a63:fa54:: with SMTP id g20mr4118039pgk.242.1554094291437;
 Sun, 31 Mar 2019 21:51:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190401035417.13738-1-lsahlber@redhat.com> <20190401035417.13738-2-lsahlber@redhat.com>
In-Reply-To: <20190401035417.13738-2-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 31 Mar 2019 23:51:19 -0500
Message-ID: <CAH2r5mt4q=-tSr9T-2fJX7EBWpYMiCe5Xy8HKbRtDkmRdN2s_w@mail.gmail.com>
Subject: Fwd: [PATCH] secdesc-ui.py: a UI to view the security descriptors on
 SMB2+ shares
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="00000000000030ab54058570c60e"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000030ab54058570c60e
Content-Type: text/plain; charset="UTF-8"

The tool that Ronnie proposed below looks useful (see below) and
attached screenshot.  With this as a sample (along with 'smbinfo' tool
in cifs-utils) and a starting point, those with python/GUI interest
should be able to extend it in very interesting ways now that we have
the ability to query server information much more broadly.  Managing
ACLs, quotas, snapshots, alerts and many other fun features across
such a broad set of servers (from Samba, to Windows, Azure and the
Cloud, Macs, NetApp and various filers).

Ronnie,
Great idea.

---------- Forwarded message ---------
From: Ronnie Sahlberg <lsahlber@redhat.com>
Date: Sun, Mar 31, 2019 at 10:54 PM
Subject: [PATCH] secdesc-ui.py: a UI to view the security descriptors
on SMB2+ shares
To: linux-cifs <linux-cifs@vger.kernel.org>
Cc: Steve French <smfrench@gmail.com>, Pavel Shilovsky
<pshilov@microsoft.com>, Ronnie Sahlberg <lsahlber@redhat.com>

a simple python program with a basic UI to view the security descriptor
for SMB2+ resources.

With a basic starting point like this my hope is we can get some interest
from people with python skills that may want to make it better until
it becomes a full-fledged utility.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 secdesc-ui.py | 421 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 421 insertions(+)
 create mode 100755 secdesc-ui.py

diff --git a/secdesc-ui.py b/secdesc-ui.py
new file mode 100755
index 0000000..dcb9dbf
--- /dev/null
+++ b/secdesc-ui.py
@@ -0,0 +1,421 @@
+#!/usr/bin/env python
+# coding: utf-8
+
+import array
+import enum
+import fcntl
+import os
+import struct
+import stat
+import sys
+from Tkinter import *
+
+FULL_CONTROL = 0x001f01ff
+EWRITE = 0x00000116
+ALL_READ_BITS = 0x00020089
+EREAD = 0x001200a9
+CHANGE = 0x001301bf
+
+TRAV_EXEC = 0x00100020
+LIST_READ = 0x00100001
+READ_ATTR = 0x00100080
+READ_XATT = 0x00100008
+CREA_WRIT = 0x00100002
+CREA_APPE = 0x00100004
+WRIT_ATTR = 0x00100100
+WRIT_XATT = 0x00100010
+DELE = 0x00110000
+READ_PERM = 0x00120000
+CHAN_PERM = 0x00140000
+TAKE_OWNR = 0x00180000
+
+class App:
+       def __init__(self, root, sd, is_dir):
+               self.sd = sd
+                self.is_dir = is_dir
+               self.tf = Frame(bd=1)
+               self.tf.grid(columnspan=5, rowspan=5, padx=5, pady=5)
+
+               # Owner
+               Label(self.tf, text='Owner: %s' %
(self.sd.owner)).grid(row=0, column=0, columnspan=6, sticky='W')
+
+               # Group
+               Label(self.tf, text='Group: %s' %
(self.sd.group)).grid(row=1, column=0, columnspan=6, sticky='W')
+
+               self.sb = Scrollbar(self.tf, orient=VERTICAL)
+               self.lb = Listbox(self.tf, height=5, selectmode=SINGLE,
+                               yscrollcommand=self.sb.set)
+               self.sb.config(command=self.lb.yview)
+               self.sb.grid(row=2, column=1, sticky='NS')
+               self.lb.grid(row=2, column=0, sticky='W')
+
+                max = 0
+               for idx, item in enumerate(self.sd.dacl.ace):
+                       if item.type != 0 and item.type != 1:
+                               continue
+                        sid = '%s %s' % ("ALLOW" if item.type == 0
else "DENY", item.sid)
+                        if max > len(sid):
+                                max = len(sid)
+                       self.lb.insert(idx, sid)
+                       if not self.lb.curselection():
+                               self.lb.selection_set(idx)
+                self.lb.config(width=max)
+                self.lb.bind("<Double-Button-1>", self.select_sid)
+
+               self.bas = Button(self.tf, text='Basic', relief=SUNKEN,
+                       command=self.click_bas)
+               self.bas.grid(row=2, column=2, sticky='NW')
+
+               self.adv = Button(self.tf, text='Advanced',
+                       command=self.click_adv)
+               self.adv.grid(row=2, column=3, sticky='NW')
+
+               # Basic Panel
+               self.bf_bas = Frame(master=self.tf, bd=1)
+               self.bf_bas.grid(row=3, column=0, columnspan=4, padx=5, pady=5)
+               self.bf_bas_name = Label(self.bf_bas, text='')
+               self.bf_bas_name.grid(row=0, column=0, columnspan=2, sticky='W')
+
+                row = 1
+               self.bf_bas_fc=Checkbutton(self.bf_bas, text='Full Control')
+               self.bf_bas_fc.grid(row=row, column=0, sticky='W')
+               self.bf_bas_fc.config(state=DISABLED)
+                row += 1
+
+               self.bf_bas_mo=Checkbutton(self.bf_bas, text='Modify')
+               self.bf_bas_mo.grid(row=row, column=0, sticky='W')
+               self.bf_bas_mo.config(state=DISABLED)
+                row += 1
+
+               self.bf_bas_re=Checkbutton(self.bf_bas, text='Read & Execute')
+               self.bf_bas_re.grid(row=row, column=0, sticky='W')
+               self.bf_bas_re.config(state=DISABLED)
+                row += 1
+
+               self.bf_bas_rd=Checkbutton(self.bf_bas, text='Read')
+               self.bf_bas_rd.grid(row=row, column=0, sticky='W')
+               self.bf_bas_rd.config(state=DISABLED)
+                row += 1
+
+               self.bf_bas_wr=Checkbutton(self.bf_bas, text='Write')
+               self.bf_bas_wr.grid(row=row, column=0, sticky='W')
+               self.bf_bas_wr.config(state=DISABLED)
+                row += 1
+
+               self.bf_bas_sp=Checkbutton(self.bf_bas, text='Special')
+               self.bf_bas_sp.grid(row=row, column=0, sticky='W')
+               self.bf_bas_sp.config(state=DISABLED)
+                row += 1
+
+               self.show_bas = True
+               self.update_bf_bas()
+
+               # Advanced Panel
+               self.bf_adv = Frame(master=self.tf, bd=1)
+               self.bf_adv.grid(row=3, column=0, columnspan=4, padx=5, pady=5)
+               self.bf_adv_name = Label(self.bf_adv, text='')
+               self.bf_adv_name.grid(row=0, column=0, columnspan=2, sticky='W')
+
+                row = 1
+               self.bf_adv_fc=Checkbutton(self.bf_adv, text='Full Control')
+               self.bf_adv_fc.grid(row=row, column=0, sticky='W')
+               self.bf_adv_fc.config(state=DISABLED)
+                row += 1
+
+               self.bf_adv_te=Checkbutton(self.bf_adv,
text='Traverse-folder/execute-file')
+               self.bf_adv_te.grid(row=row, column=0, sticky='W')
+               self.bf_adv_te.config(state=DISABLED)
+                row += 1
+
+               self.bf_adv_lr=Checkbutton(self.bf_adv,
text='List-folder/read-data')
+               self.bf_adv_lr.grid(row=row, column=0, sticky='W')
+               self.bf_adv_lr.config(state=DISABLED)
+                row += 1
+
+               self.bf_adv_ra=Checkbutton(self.bf_adv, text='Read-Attributes')
+               self.bf_adv_ra.grid(row=row, column=0, sticky='W')
+               self.bf_adv_ra.config(state=DISABLED)
+                row += 1
+
+               self.bf_adv_re=Checkbutton(self.bf_adv,
text='Read-Extended-Attributes')
+               self.bf_adv_re.grid(row=row, column=0, sticky='W')
+               self.bf_adv_re.config(state=DISABLED)
+                row += 1
+
+               self.bf_adv_cw=Checkbutton(self.bf_adv,
text='Create-files/write-data')
+               self.bf_adv_cw.grid(row=row, column=0, sticky='W')
+               self.bf_adv_cw.config(state=DISABLED)
+                row += 1
+
+               self.bf_adv_ca=Checkbutton(self.bf_adv,
text='Create-folders/append-data')
+               self.bf_adv_ca.grid(row=row, column=0, sticky='W')
+               self.bf_adv_ca.config(state=DISABLED)
+                row += 1
+
+                row = 1
+               self.bf_adv_wa=Checkbutton(self.bf_adv, text='Write-Attributes')
+               self.bf_adv_wa.grid(row=row, column=1, sticky='W')
+               self.bf_adv_wa.config(state=DISABLED)
+                row += 1
+
+               self.bf_adv_we=Checkbutton(self.bf_adv,
text='Write-Extended-Attributes')
+               self.bf_adv_we.grid(row=row, column=1, sticky='W')
+               self.bf_adv_we.config(state=DISABLED)
+                row += 1
+
+               self.bf_adv_de=Checkbutton(self.bf_adv, text='Delete')
+               self.bf_adv_de.grid(row=row, column=1, sticky='W')
+               self.bf_adv_de.config(state=DISABLED)
+                row += 1
+
+               self.bf_adv_rp=Checkbutton(self.bf_adv, text='Read-Permissions')
+               self.bf_adv_rp.grid(row=row, column=1, sticky='W')
+               self.bf_adv_rp.config(state=DISABLED)
+                row += 1
+
+               self.bf_adv_cp=Checkbutton(self.bf_adv,
text='Change-Permissions')
+               self.bf_adv_cp.grid(row=row, column=1, sticky='W')
+               self.bf_adv_cp.config(state=DISABLED)
+                row += 1
+
+               self.bf_adv_to=Checkbutton(self.bf_adv, text='Take-Ownership')
+               self.bf_adv_to.grid(row=row, column=1, sticky='W')
+               self.bf_adv_to.config(state=DISABLED)
+                row += 1
+
+               self.bf_adv.grid_remove()
+
+       def select_sid(self, event):
+                self.click_bas()
+
+       def click_bas(self):
+               self.adv.config(relief=RAISED)
+               self.bas.config(relief=SUNKEN)
+               self.bf_adv.grid_remove()
+               self.update_bf_bas()
+               self.bf_bas.grid()
+               self.show_bas = True
+
+       def click_adv(self):
+               self.adv.config(relief=SUNKEN)
+               self.bas.config(relief=RAISED)
+               self.bf_bas.grid_remove()
+               self.update_bf_adv()
+               self.bf_adv.grid()
+               self.show_bas = False
+
+       def update_bf_adv(self):
+               ace = self.sd.dacl.ace[self.lb.curselection()[0]]
+               self.bf_adv_name.config(text='Advanced Permissions for
%s' % (ace.sid))
+               if ace.mask == FULL_CONTROL:
+                       self.bf_adv_fc.select()
+               else:
+                       self.bf_adv_fc.deselect()
+               if ace.mask & TRAV_EXEC == TRAV_EXEC:
+                       self.bf_adv_te.select()
+               else:
+                       self.bf_adv_te.deselect()
+               if ace.mask & LIST_READ == LIST_READ:
+                       self.bf_adv_lr.select()
+               else:
+                       self.bf_adv_lr.deselect()
+               if ace.mask & READ_ATTR == READ_ATTR:
+                       self.bf_adv_ra.select()
+               else:
+                       self.bf_adv_ra.deselect()
+               if ace.mask & READ_XATT == READ_XATT:
+                       self.bf_adv_re.select()
+               else:
+                       self.bf_adv_re.deselect()
+               if ace.mask & CREA_WRIT == CREA_WRIT:
+                       self.bf_adv_cw.select()
+               else:
+                       self.bf_adv_cw.deselect()
+               if ace.mask & CREA_APPE == CREA_APPE:
+                       self.bf_adv_ca.select()
+               else:
+                       self.bf_adv_ca.deselect()
+               if ace.mask & WRIT_ATTR == WRIT_ATTR:
+                       self.bf_adv_wa.select()
+               else:
+                       self.bf_adv_wa.deselect()
+               if ace.mask & WRIT_XATT == WRIT_XATT:
+                       self.bf_adv_we.select()
+               else:
+                       self.bf_adv_we.deselect()
+               if ace.mask & DELE == DELE:
+                       self.bf_adv_de.select()
+               else:
+                       self.bf_adv_de.deselect()
+               if ace.mask & READ_PERM == READ_PERM:
+                       self.bf_adv_rp.select()
+               else:
+                       self.bf_adv_rp.deselect()
+               if ace.mask & CHAN_PERM == CHAN_PERM:
+                       self.bf_adv_rp.select()
+               else:
+                       self.bf_adv_rp.deselect()
+               if ace.mask & TAKE_OWNR == TAKE_OWNR:
+                       self.bf_adv_to.select()
+               else:
+                       self.bf_adv_to.deselect()
+
+       def update_bf_bas(self):
+               ace = self.sd.dacl.ace[self.lb.curselection()[0]]
+               self.bf_bas_name.config(text='Permissions for %s' % (ace.sid))
+               tmp = ace.mask
+               if ace.mask == FULL_CONTROL:
+                       self.bf_bas_fc.select()
+                       tmp &= ~FULL_CONTROL
+               else:
+                       self.bf_bas_fc.deselect()
+               if ace.mask & CHANGE == CHANGE:
+                       self.bf_bas_mo.select()
+                       tmp &= ~CHANGE
+               else:
+                       self.bf_bas_mo.deselect()
+               if ace.mask & EREAD == EREAD:
+                       self.bf_bas_re.select()
+                       tmp &= ~EREAD
+               else:
+                       self.bf_bas_re.deselect()
+               if ace.mask & ALL_READ_BITS == ALL_READ_BITS:
+                       self.bf_bas_rd.select()
+                       tmp &= ~ALL_READ_BITS
+               else:
+                       self.bf_bas_rd.deselect()
+               if ace.mask & EWRITE == EWRITE:
+                       self.bf_bas_wr.select()
+                       tmp &= ~EWRITE
+               else:
+                       self.bf_bas_wr.deselect()
+               if tmp:
+                       self.bf_bas_sp.select()
+               else:
+                       self.bf_bas_sp.deselect()
+
+CIFS_QUERY_INFO = 0xc018cf07
+
+def usage():
+        print "Usage: %s <filename>" % (sys.argv[0])
+        sys.exit()
+
+class SID:
+        def __init__(self, buf):
+                self.sub_authority_count = buf[1]
+                self.buffer = buf[:8 + self.sub_authority_count * 4]
+                self.revision = self.buffer[0]
+                if self.revision != 1:
+                        raise ValueError('SID Revision %d not supported' %
+                                         (self.revision))
+                self.identifier_authority = 0
+                for x in self.buffer[2:8]:
+                        self.identifier_authority =
self.identifier_authority * 256 + x
+                self.sub_authority = []
+                for i in range(self.sub_authority_count):
+
self.sub_authority.append(struct.unpack_from('<I', self.buffer, 8 + 4
* i)[0])
+
+        def __str__(self):
+                s = "S-%u-%u" % (self.revision, self.identifier_authority)
+
+                for x in self.sub_authority:
+                        s += '-%u' % x
+                return s
+
+
+class ACE:
+        def __init__(self, buf):
+                self.type = buf[0]
+                self.flags = buf[1]
+                self.size = struct.unpack_from('<H', buf, 2)[0]
+                self.raw = buf[:self.size]
+                if self.type in [0, 1]:
+                        self.mask = struct.unpack_from('<I', buf, 4)[0]
+                        self.sid = SID(buf[8:])
+
+        def __str__(self):
+                s = 'Type:0x%02x ' % (self.type)
+                s += 'Flags:0x%02x ' % (self.flags)
+                if self.type in [0, 1]:
+                        s += 'Mask:0x%02x SID:%s' % (self.mask, self.sid)
+                else:
+                        for i in self.raw[4:]:
+                                s += '%02x' % (i)
+
+                return s
+
+        class Type(enum.Enum):
+                ALLOWED = 0
+                DENIED = 1
+
+                def __str__(self):
+                        return self.name
+
+class ACL:
+        def __init__(self, buf):
+                self.revision = buf[0]
+                if self.revision != 2 and self.revision != 4:
+                        raise ValueError('ACL Revision %d '
+                                         'not supported' % (self.revision))
+                acl = buf[8:8 + struct.unpack_from('<H', buf, 2)[0]]
+                self.ace = []
+                for i in range(struct.unpack_from('<H', buf, 4)[0]):
+                        ace = ACE(acl)
+                        self.ace.append(ace)
+                        acl = acl[ace.size:]
+
+        def __str__(self):
+                s = 'Revision:0x%02x\n' % (self.revision)
+                for ace in self.ace:
+                        s += '%s\n' % (ace)
+                return s
+
+class SecurityDescriptor:
+        def __init__(self, buf):
+                self.revision = buf[0]
+                if self.revision != 1:
+                        raise ValueError('Security Descriptor Revision %d '
+                                         'not supported' % (self.revision))
+                self.control = struct.unpack_from('<H', buf, 2)
+
+                self.owner = SID(buf[struct.unpack_from('<I', buf, 4)[0]:])
+                self.group = SID(buf[struct.unpack_from('<I', buf, 8)[0]:])
+
+                self.dacl = ACL(buf[struct.unpack_from('<I', buf, 16)[0]:])
+
+        def __str__(self):
+                s = 'Revision:%u\n' % (self.revision)
+                s += 'Control:0x%04x\n' % (self.control)
+                s += 'Owner:%s\n' % (self.owner)
+                s += 'Group:%s\n' % (self.group)
+                s += 'DACL:\n%s' % (self.dacl)
+                return s
+
+def main():
+        if len(sys.argv) != 2:
+                usage()
+
+        buf = array.array('B', [0] * 16384)
+
+        struct.pack_into('<I', buf, 0, 3) # InfoType: Security
+        struct.pack_into('<I', buf, 8, 7) # AddInfo: Group/Owner/Dacl
+        struct.pack_into('<I', buf, 16, 16384) # InputBufferLength
+
+        #with open(sys.argv[1], 'r') as f:
+        f = os.open(sys.argv[1], os.O_RDONLY)
+        st = os.fstat(f)
+        fcntl.ioctl(f, CIFS_QUERY_INFO, buf, 1)
+       os.close(f)
+
+        s = struct.unpack_from('<I', buf, 16)
+
+        sd = SecurityDescriptor(buf[24:24 + s[0]])
+
+        root = Tk()
+        app = App(root, sd, stat.S_ISDIR(st.st_mode))
+        root.mainloop()
+
+
+if __name__ == "__main__":
+       main()
+
--
2.13.6



-- 
Thanks,

Steve

--00000000000030ab54058570c60e
Content-Type: image/png; name="Screenshot-of-new-secdesc-ui-tool.png"
Content-Disposition: attachment; 
	filename="Screenshot-of-new-secdesc-ui-tool.png"
Content-Transfer-Encoding: base64
Content-ID: <f_jtxvlho60>
X-Attachment-Id: f_jtxvlho60

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
4T2cuMiOMh/ymZE0fU98n7t2HM93nv4P//3b1zneODc5p3qf564rz+cdq1bSsuIIjjvtA3zqKz/n
pcBU39yTpvfZH3DlJz/AO45sYUnLR/jVDq2QcZRXbjmV5sWLx6+HxSxevJTjr/8XU8Z56T5evHs1
n37/KRy5fBkrVr2DD119D//17iprJvVI8MYvL+fDZ53EqkNaaDn0ON594Q38YUOI3a1V/bz6i6s5
96TDWHHIMZz5qW/zzI7R/NMD0W1Pcttn38sJh61g5ZEnc87F9/BaMp8659emqfPXqr9G+tFWbjql
edIYjf8sOZyr/xafWZ9q5TkH46wG1nLfVz7CaatWsKzlME445xJu/0vX7msr7Wvlnqv/h1OOXMHy
w07kA//3k4n8NcvXvnZzlq+ZfzYabdYcJ60+m8Z8VL08ffWJNC9eweV/mrRya1xnucdEq3yt4/nN
w2n1aR5tynl8RuO8/+T8str9Kt3PM0+8yVEfey/bn1rDpov/j2X6A12pA0XBedoN/PbKVegTPjY8
8h1uvPbz6Koe56tHWKaZV4pkEozGaXam4uLoi27k6GmWts/ymRGVgZ196Bo/ypGVbswzyiNL/6W2
cPdll/FL/Xlc84Ovs7IY/D2befmf2/FGVXBnCwVVEjEoO+JcLj/uJb73g4E8y1ewnnwtv/y/I8cn
q4KhsGbqiZvaygsvBGh635V8ZGk1ruCr3H/b97nkChOP/PLj1OpnVg9dwTLee+kHWVjpwRzt4Ll7
v811n01S+tRNnGhP0//4tXz+zkHOufl+vtMQ5B/f+zJfvMzCbx66jGVGrfSQ7nmYqz5xKwOnXsp1
P1lJqX6Enq0x7Eo+fafdptz5a9c/Z3r9cj5998Ocm1R318f/15u45P4S3nGEaWZ9atPIc7bjrI7w
15su5TvrT2T1Xd/g6JIYmx7+Ftd+8WoKFv6Oi+p38sDVn+en4fdzw7230WLt4dkfrOayK+38/hcX
UJvWKh9yXrta5dfkk38mjTZrjlM6j7mRz3xM07/mG3y/t5Hltlf2/Huu68yg0ScL8yk/93GteTjt
PtWcOxrHmck47z/zJkBK73iKx7ccxf9+53zeePFLPPHG51l26MTbfXVkLb9YfR33PNdJsvRQzv3C
6SQBM2l2/OqjnP3Ho3jgkctZsqtDo8/x1dO+TOK6Z7j9NCtbHr6R2379POu2DxI1V7DizM/y9Ws+
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
IYQQQvT5/yl/wxKUe259AAAAAElFTkSuQmCC
--00000000000030ab54058570c60e
Content-Type: text/x-python; charset="US-ASCII"; name="secdesc-ui.py"
Content-Disposition: attachment; filename="secdesc-ui.py"
Content-Transfer-Encoding: base64
Content-ID: <f_jtxvlq6e1>
X-Attachment-Id: f_jtxvlq6e1

IyEvdXNyL2Jpbi9lbnYgcHl0aG9uCiMgY29kaW5nOiB1dGYtOAoKaW1wb3J0IGFycmF5CmltcG9y
dCBlbnVtCmltcG9ydCBmY250bAppbXBvcnQgb3MKaW1wb3J0IHN0cnVjdAppbXBvcnQgc3RhdApp
bXBvcnQgc3lzCmZyb20gVGtpbnRlciBpbXBvcnQgKgoKRlVMTF9DT05UUk9MID0gMHgwMDFmMDFm
ZgpFV1JJVEUgPSAweDAwMDAwMTE2CkFMTF9SRUFEX0JJVFMgPSAweDAwMDIwMDg5CkVSRUFEID0g
MHgwMDEyMDBhOQpDSEFOR0UgPSAweDAwMTMwMWJmCgpUUkFWX0VYRUMgPSAweDAwMTAwMDIwCkxJ
U1RfUkVBRCA9IDB4MDAxMDAwMDEKUkVBRF9BVFRSID0gMHgwMDEwMDA4MApSRUFEX1hBVFQgPSAw
eDAwMTAwMDA4CkNSRUFfV1JJVCA9IDB4MDAxMDAwMDIKQ1JFQV9BUFBFID0gMHgwMDEwMDAwNApX
UklUX0FUVFIgPSAweDAwMTAwMTAwCldSSVRfWEFUVCA9IDB4MDAxMDAwMTAKREVMRSA9IDB4MDAx
MTAwMDAKUkVBRF9QRVJNID0gMHgwMDEyMDAwMApDSEFOX1BFUk0gPSAweDAwMTQwMDAwClRBS0Vf
T1dOUiA9IDB4MDAxODAwMDAKCmNsYXNzIEFwcDoKCWRlZiBfX2luaXRfXyhzZWxmLCByb290LCBz
ZCwgaXNfZGlyKToKCQlzZWxmLnNkID0gc2QKICAgICAgICAgICAgICAgIHNlbGYuaXNfZGlyID0g
aXNfZGlyCgkJc2VsZi50ZiA9IEZyYW1lKGJkPTEpCgkJc2VsZi50Zi5ncmlkKGNvbHVtbnNwYW49
NSwgcm93c3Bhbj01LCBwYWR4PTUsIHBhZHk9NSkKCgkJIyBPd25lcgoJCUxhYmVsKHNlbGYudGYs
IHRleHQ9J093bmVyOiAlcycgJSAoc2VsZi5zZC5vd25lcikpLmdyaWQocm93PTAsIGNvbHVtbj0w
LCBjb2x1bW5zcGFuPTYsIHN0aWNreT0nVycpCgoJCSMgR3JvdXAgCgkJTGFiZWwoc2VsZi50Ziwg
dGV4dD0nR3JvdXA6ICVzJyAlIChzZWxmLnNkLmdyb3VwKSkuZ3JpZChyb3c9MSwgY29sdW1uPTAs
IGNvbHVtbnNwYW49Niwgc3RpY2t5PSdXJykKCgkJc2VsZi5zYiA9IFNjcm9sbGJhcihzZWxmLnRm
LCBvcmllbnQ9VkVSVElDQUwpCgkJc2VsZi5sYiA9IExpc3Rib3goc2VsZi50ZiwgaGVpZ2h0PTUs
IHNlbGVjdG1vZGU9U0lOR0xFLAoJCQkJeXNjcm9sbGNvbW1hbmQ9c2VsZi5zYi5zZXQpCgkJc2Vs
Zi5zYi5jb25maWcoY29tbWFuZD1zZWxmLmxiLnl2aWV3KQoJCXNlbGYuc2IuZ3JpZChyb3c9Miwg
Y29sdW1uPTEsIHN0aWNreT0nTlMnKQoJCXNlbGYubGIuZ3JpZChyb3c9MiwgY29sdW1uPTAsIHN0
aWNreT0nVycpCgogICAgICAgICAgICAgICAgbWF4ID0gMAoJCWZvciBpZHgsIGl0ZW0gaW4gZW51
bWVyYXRlKHNlbGYuc2QuZGFjbC5hY2UpOgoJCQlpZiBpdGVtLnR5cGUgIT0gMCBhbmQgaXRlbS50
eXBlICE9IDE6CgkJCQljb250aW51ZQogICAgICAgICAgICAgICAgICAgICAgICBzaWQgPSAnJXMg
JXMnICUgKCJBTExPVyIgaWYgaXRlbS50eXBlID09IDAgZWxzZSAiREVOWSIsIGl0ZW0uc2lkKQog
ICAgICAgICAgICAgICAgICAgICAgICBpZiBtYXggPiBsZW4oc2lkKToKICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBtYXggPSBsZW4oc2lkKQoJCQlzZWxmLmxiLmluc2VydChpZHgsIHNp
ZCkKCQkJaWYgbm90IHNlbGYubGIuY3Vyc2VsZWN0aW9uKCk6CgkJCQlzZWxmLmxiLnNlbGVjdGlv
bl9zZXQoaWR4KQogICAgICAgICAgICAgICAgc2VsZi5sYi5jb25maWcod2lkdGg9bWF4KQogICAg
ICAgICAgICAgICAgc2VsZi5sYi5iaW5kKCI8RG91YmxlLUJ1dHRvbi0xPiIsIHNlbGYuc2VsZWN0
X3NpZCkKCgkJc2VsZi5iYXMgPSBCdXR0b24oc2VsZi50ZiwgdGV4dD0nQmFzaWMnLCByZWxpZWY9
U1VOS0VOLAoJCQljb21tYW5kPXNlbGYuY2xpY2tfYmFzKQoJCXNlbGYuYmFzLmdyaWQocm93PTIs
IGNvbHVtbj0yLCBzdGlja3k9J05XJykKCgkJc2VsZi5hZHYgPSBCdXR0b24oc2VsZi50ZiwgdGV4
dD0nQWR2YW5jZWQnLAoJCQljb21tYW5kPXNlbGYuY2xpY2tfYWR2KQoJCXNlbGYuYWR2LmdyaWQo
cm93PTIsIGNvbHVtbj0zLCBzdGlja3k9J05XJykKCgkJIyBCYXNpYyBQYW5lbAoJCXNlbGYuYmZf
YmFzID0gRnJhbWUobWFzdGVyPXNlbGYudGYsIGJkPTEpCgkJc2VsZi5iZl9iYXMuZ3JpZChyb3c9
MywgY29sdW1uPTAsIGNvbHVtbnNwYW49NCwgcGFkeD01LCBwYWR5PTUpCgkJc2VsZi5iZl9iYXNf
bmFtZSA9IExhYmVsKHNlbGYuYmZfYmFzLCB0ZXh0PScnKQoJCXNlbGYuYmZfYmFzX25hbWUuZ3Jp
ZChyb3c9MCwgY29sdW1uPTAsIGNvbHVtbnNwYW49Miwgc3RpY2t5PSdXJykKCiAgICAgICAgICAg
ICAgICByb3cgPSAxCgkJc2VsZi5iZl9iYXNfZmM9Q2hlY2tidXR0b24oc2VsZi5iZl9iYXMsIHRl
eHQ9J0Z1bGwgQ29udHJvbCcpCgkJc2VsZi5iZl9iYXNfZmMuZ3JpZChyb3c9cm93LCBjb2x1bW49
MCwgc3RpY2t5PSdXJykKCQlzZWxmLmJmX2Jhc19mYy5jb25maWcoc3RhdGU9RElTQUJMRUQpCiAg
ICAgICAgICAgICAgICByb3cgKz0gMQoKCQlzZWxmLmJmX2Jhc19tbz1DaGVja2J1dHRvbihzZWxm
LmJmX2JhcywgdGV4dD0nTW9kaWZ5JykKCQlzZWxmLmJmX2Jhc19tby5ncmlkKHJvdz1yb3csIGNv
bHVtbj0wLCBzdGlja3k9J1cnKQoJCXNlbGYuYmZfYmFzX21vLmNvbmZpZyhzdGF0ZT1ESVNBQkxF
RCkKICAgICAgICAgICAgICAgIHJvdyArPSAxCgoJCXNlbGYuYmZfYmFzX3JlPUNoZWNrYnV0dG9u
KHNlbGYuYmZfYmFzLCB0ZXh0PSdSZWFkICYgRXhlY3V0ZScpCgkJc2VsZi5iZl9iYXNfcmUuZ3Jp
ZChyb3c9cm93LCBjb2x1bW49MCwgc3RpY2t5PSdXJykKCQlzZWxmLmJmX2Jhc19yZS5jb25maWco
c3RhdGU9RElTQUJMRUQpCiAgICAgICAgICAgICAgICByb3cgKz0gMQoKCQlzZWxmLmJmX2Jhc19y
ZD1DaGVja2J1dHRvbihzZWxmLmJmX2JhcywgdGV4dD0nUmVhZCcpCgkJc2VsZi5iZl9iYXNfcmQu
Z3JpZChyb3c9cm93LCBjb2x1bW49MCwgc3RpY2t5PSdXJykKCQlzZWxmLmJmX2Jhc19yZC5jb25m
aWcoc3RhdGU9RElTQUJMRUQpCiAgICAgICAgICAgICAgICByb3cgKz0gMQoKCQlzZWxmLmJmX2Jh
c193cj1DaGVja2J1dHRvbihzZWxmLmJmX2JhcywgdGV4dD0nV3JpdGUnKQoJCXNlbGYuYmZfYmFz
X3dyLmdyaWQocm93PXJvdywgY29sdW1uPTAsIHN0aWNreT0nVycpCgkJc2VsZi5iZl9iYXNfd3Iu
Y29uZmlnKHN0YXRlPURJU0FCTEVEKQogICAgICAgICAgICAgICAgcm93ICs9IDEKCgkJc2VsZi5i
Zl9iYXNfc3A9Q2hlY2tidXR0b24oc2VsZi5iZl9iYXMsIHRleHQ9J1NwZWNpYWwnKQoJCXNlbGYu
YmZfYmFzX3NwLmdyaWQocm93PXJvdywgY29sdW1uPTAsIHN0aWNreT0nVycpCgkJc2VsZi5iZl9i
YXNfc3AuY29uZmlnKHN0YXRlPURJU0FCTEVEKQogICAgICAgICAgICAgICAgcm93ICs9IDEKCgkJ
c2VsZi5zaG93X2JhcyA9IFRydWUKCQlzZWxmLnVwZGF0ZV9iZl9iYXMoKQoJCgkJIyBBZHZhbmNl
ZCBQYW5lbAkKCQlzZWxmLmJmX2FkdiA9IEZyYW1lKG1hc3Rlcj1zZWxmLnRmLCBiZD0xKQoJCXNl
bGYuYmZfYWR2LmdyaWQocm93PTMsIGNvbHVtbj0wLCBjb2x1bW5zcGFuPTQsIHBhZHg9NSwgcGFk
eT01KQoJCXNlbGYuYmZfYWR2X25hbWUgPSBMYWJlbChzZWxmLmJmX2FkdiwgdGV4dD0nJykKCQlz
ZWxmLmJmX2Fkdl9uYW1lLmdyaWQocm93PTAsIGNvbHVtbj0wLCBjb2x1bW5zcGFuPTIsIHN0aWNr
eT0nVycpCiAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgIHJvdyA9IDEKCQlzZWxmLmJm
X2Fkdl9mYz1DaGVja2J1dHRvbihzZWxmLmJmX2FkdiwgdGV4dD0nRnVsbCBDb250cm9sJykKCQlz
ZWxmLmJmX2Fkdl9mYy5ncmlkKHJvdz1yb3csIGNvbHVtbj0wLCBzdGlja3k9J1cnKQoJCXNlbGYu
YmZfYWR2X2ZjLmNvbmZpZyhzdGF0ZT1ESVNBQkxFRCkKICAgICAgICAgICAgICAgIHJvdyArPSAx
CgoJCXNlbGYuYmZfYWR2X3RlPUNoZWNrYnV0dG9uKHNlbGYuYmZfYWR2LCB0ZXh0PSdUcmF2ZXJz
ZS1mb2xkZXIvZXhlY3V0ZS1maWxlJykKCQlzZWxmLmJmX2Fkdl90ZS5ncmlkKHJvdz1yb3csIGNv
bHVtbj0wLCBzdGlja3k9J1cnKQoJCXNlbGYuYmZfYWR2X3RlLmNvbmZpZyhzdGF0ZT1ESVNBQkxF
RCkKICAgICAgICAgICAgICAgIHJvdyArPSAxCgoJCXNlbGYuYmZfYWR2X2xyPUNoZWNrYnV0dG9u
KHNlbGYuYmZfYWR2LCB0ZXh0PSdMaXN0LWZvbGRlci9yZWFkLWRhdGEnKQoJCXNlbGYuYmZfYWR2
X2xyLmdyaWQocm93PXJvdywgY29sdW1uPTAsIHN0aWNreT0nVycpCgkJc2VsZi5iZl9hZHZfbHIu
Y29uZmlnKHN0YXRlPURJU0FCTEVEKQogICAgICAgICAgICAgICAgcm93ICs9IDEKCgkJc2VsZi5i
Zl9hZHZfcmE9Q2hlY2tidXR0b24oc2VsZi5iZl9hZHYsIHRleHQ9J1JlYWQtQXR0cmlidXRlcycp
CgkJc2VsZi5iZl9hZHZfcmEuZ3JpZChyb3c9cm93LCBjb2x1bW49MCwgc3RpY2t5PSdXJykKCQlz
ZWxmLmJmX2Fkdl9yYS5jb25maWcoc3RhdGU9RElTQUJMRUQpCiAgICAgICAgICAgICAgICByb3cg
Kz0gMQoKCQlzZWxmLmJmX2Fkdl9yZT1DaGVja2J1dHRvbihzZWxmLmJmX2FkdiwgdGV4dD0nUmVh
ZC1FeHRlbmRlZC1BdHRyaWJ1dGVzJykKCQlzZWxmLmJmX2Fkdl9yZS5ncmlkKHJvdz1yb3csIGNv
bHVtbj0wLCBzdGlja3k9J1cnKQoJCXNlbGYuYmZfYWR2X3JlLmNvbmZpZyhzdGF0ZT1ESVNBQkxF
RCkKICAgICAgICAgICAgICAgIHJvdyArPSAxCgoJCXNlbGYuYmZfYWR2X2N3PUNoZWNrYnV0dG9u
KHNlbGYuYmZfYWR2LCB0ZXh0PSdDcmVhdGUtZmlsZXMvd3JpdGUtZGF0YScpCgkJc2VsZi5iZl9h
ZHZfY3cuZ3JpZChyb3c9cm93LCBjb2x1bW49MCwgc3RpY2t5PSdXJykKCQlzZWxmLmJmX2Fkdl9j
dy5jb25maWcoc3RhdGU9RElTQUJMRUQpCiAgICAgICAgICAgICAgICByb3cgKz0gMQoKCQlzZWxm
LmJmX2Fkdl9jYT1DaGVja2J1dHRvbihzZWxmLmJmX2FkdiwgdGV4dD0nQ3JlYXRlLWZvbGRlcnMv
YXBwZW5kLWRhdGEnKQoJCXNlbGYuYmZfYWR2X2NhLmdyaWQocm93PXJvdywgY29sdW1uPTAsIHN0
aWNreT0nVycpCgkJc2VsZi5iZl9hZHZfY2EuY29uZmlnKHN0YXRlPURJU0FCTEVEKQogICAgICAg
ICAgICAgICAgcm93ICs9IDEKCiAgICAgICAgICAgICAgICByb3cgPSAxCgkJc2VsZi5iZl9hZHZf
d2E9Q2hlY2tidXR0b24oc2VsZi5iZl9hZHYsIHRleHQ9J1dyaXRlLUF0dHJpYnV0ZXMnKQoJCXNl
bGYuYmZfYWR2X3dhLmdyaWQocm93PXJvdywgY29sdW1uPTEsIHN0aWNreT0nVycpCgkJc2VsZi5i
Zl9hZHZfd2EuY29uZmlnKHN0YXRlPURJU0FCTEVEKQogICAgICAgICAgICAgICAgcm93ICs9IDEK
CgkJc2VsZi5iZl9hZHZfd2U9Q2hlY2tidXR0b24oc2VsZi5iZl9hZHYsIHRleHQ9J1dyaXRlLUV4
dGVuZGVkLUF0dHJpYnV0ZXMnKQoJCXNlbGYuYmZfYWR2X3dlLmdyaWQocm93PXJvdywgY29sdW1u
PTEsIHN0aWNreT0nVycpCgkJc2VsZi5iZl9hZHZfd2UuY29uZmlnKHN0YXRlPURJU0FCTEVEKQog
ICAgICAgICAgICAgICAgcm93ICs9IDEKCgkJc2VsZi5iZl9hZHZfZGU9Q2hlY2tidXR0b24oc2Vs
Zi5iZl9hZHYsIHRleHQ9J0RlbGV0ZScpCgkJc2VsZi5iZl9hZHZfZGUuZ3JpZChyb3c9cm93LCBj
b2x1bW49MSwgc3RpY2t5PSdXJykKCQlzZWxmLmJmX2Fkdl9kZS5jb25maWcoc3RhdGU9RElTQUJM
RUQpCiAgICAgICAgICAgICAgICByb3cgKz0gMQoKCQlzZWxmLmJmX2Fkdl9ycD1DaGVja2J1dHRv
bihzZWxmLmJmX2FkdiwgdGV4dD0nUmVhZC1QZXJtaXNzaW9ucycpCgkJc2VsZi5iZl9hZHZfcnAu
Z3JpZChyb3c9cm93LCBjb2x1bW49MSwgc3RpY2t5PSdXJykKCQlzZWxmLmJmX2Fkdl9ycC5jb25m
aWcoc3RhdGU9RElTQUJMRUQpCiAgICAgICAgICAgICAgICByb3cgKz0gMQoKCQlzZWxmLmJmX2Fk
dl9jcD1DaGVja2J1dHRvbihzZWxmLmJmX2FkdiwgdGV4dD0nQ2hhbmdlLVBlcm1pc3Npb25zJykK
CQlzZWxmLmJmX2Fkdl9jcC5ncmlkKHJvdz1yb3csIGNvbHVtbj0xLCBzdGlja3k9J1cnKQoJCXNl
bGYuYmZfYWR2X2NwLmNvbmZpZyhzdGF0ZT1ESVNBQkxFRCkKICAgICAgICAgICAgICAgIHJvdyAr
PSAxCgoJCXNlbGYuYmZfYWR2X3RvPUNoZWNrYnV0dG9uKHNlbGYuYmZfYWR2LCB0ZXh0PSdUYWtl
LU93bmVyc2hpcCcpCgkJc2VsZi5iZl9hZHZfdG8uZ3JpZChyb3c9cm93LCBjb2x1bW49MSwgc3Rp
Y2t5PSdXJykKCQlzZWxmLmJmX2Fkdl90by5jb25maWcoc3RhdGU9RElTQUJMRUQpCiAgICAgICAg
ICAgICAgICByb3cgKz0gMQoKCQlzZWxmLmJmX2Fkdi5ncmlkX3JlbW92ZSgpCgoJZGVmIHNlbGVj
dF9zaWQoc2VsZiwgZXZlbnQpOgogICAgICAgICAgICAgICAgc2VsZi5jbGlja19iYXMoKQoKCWRl
ZiBjbGlja19iYXMoc2VsZik6CgkJc2VsZi5hZHYuY29uZmlnKHJlbGllZj1SQUlTRUQpCgkJc2Vs
Zi5iYXMuY29uZmlnKHJlbGllZj1TVU5LRU4pCgkJc2VsZi5iZl9hZHYuZ3JpZF9yZW1vdmUoKQoJ
CXNlbGYudXBkYXRlX2JmX2JhcygpCgkJc2VsZi5iZl9iYXMuZ3JpZCgpCgkJc2VsZi5zaG93X2Jh
cyA9IFRydWUKCglkZWYgY2xpY2tfYWR2KHNlbGYpOgoJCXNlbGYuYWR2LmNvbmZpZyhyZWxpZWY9
U1VOS0VOKQoJCXNlbGYuYmFzLmNvbmZpZyhyZWxpZWY9UkFJU0VEKQoJCXNlbGYuYmZfYmFzLmdy
aWRfcmVtb3ZlKCkKCQlzZWxmLnVwZGF0ZV9iZl9hZHYoKQoJCXNlbGYuYmZfYWR2LmdyaWQoKQoJ
CXNlbGYuc2hvd19iYXMgPSBGYWxzZQoKCWRlZiB1cGRhdGVfYmZfYWR2KHNlbGYpOgoJCWFjZSA9
IHNlbGYuc2QuZGFjbC5hY2Vbc2VsZi5sYi5jdXJzZWxlY3Rpb24oKVswXV0KCQlzZWxmLmJmX2Fk
dl9uYW1lLmNvbmZpZyh0ZXh0PSdBZHZhbmNlZCBQZXJtaXNzaW9ucyBmb3IgJXMnICUgKGFjZS5z
aWQpKQoJCWlmIGFjZS5tYXNrID09IEZVTExfQ09OVFJPTDoKCQkJc2VsZi5iZl9hZHZfZmMuc2Vs
ZWN0KCkKCQllbHNlOgoJCQlzZWxmLmJmX2Fkdl9mYy5kZXNlbGVjdCgpCgkJaWYgYWNlLm1hc2sg
JiBUUkFWX0VYRUMgPT0gVFJBVl9FWEVDOgoJCQlzZWxmLmJmX2Fkdl90ZS5zZWxlY3QoKQoJCWVs
c2U6CgkJCXNlbGYuYmZfYWR2X3RlLmRlc2VsZWN0KCkKCQlpZiBhY2UubWFzayAmIExJU1RfUkVB
RCA9PSBMSVNUX1JFQUQ6CgkJCXNlbGYuYmZfYWR2X2xyLnNlbGVjdCgpCgkJZWxzZToKCQkJc2Vs
Zi5iZl9hZHZfbHIuZGVzZWxlY3QoKQoJCWlmIGFjZS5tYXNrICYgUkVBRF9BVFRSID09IFJFQURf
QVRUUjoKCQkJc2VsZi5iZl9hZHZfcmEuc2VsZWN0KCkKCQllbHNlOgoJCQlzZWxmLmJmX2Fkdl9y
YS5kZXNlbGVjdCgpCgkJaWYgYWNlLm1hc2sgJiBSRUFEX1hBVFQgPT0gUkVBRF9YQVRUOgoJCQlz
ZWxmLmJmX2Fkdl9yZS5zZWxlY3QoKQoJCWVsc2U6CgkJCXNlbGYuYmZfYWR2X3JlLmRlc2VsZWN0
KCkKCQlpZiBhY2UubWFzayAmIENSRUFfV1JJVCA9PSBDUkVBX1dSSVQ6CgkJCXNlbGYuYmZfYWR2
X2N3LnNlbGVjdCgpCgkJZWxzZToKCQkJc2VsZi5iZl9hZHZfY3cuZGVzZWxlY3QoKQoJCWlmIGFj
ZS5tYXNrICYgQ1JFQV9BUFBFID09IENSRUFfQVBQRToKCQkJc2VsZi5iZl9hZHZfY2Euc2VsZWN0
KCkKCQllbHNlOgoJCQlzZWxmLmJmX2Fkdl9jYS5kZXNlbGVjdCgpCgkJaWYgYWNlLm1hc2sgJiBX
UklUX0FUVFIgPT0gV1JJVF9BVFRSOgoJCQlzZWxmLmJmX2Fkdl93YS5zZWxlY3QoKQoJCWVsc2U6
CgkJCXNlbGYuYmZfYWR2X3dhLmRlc2VsZWN0KCkKCQlpZiBhY2UubWFzayAmIFdSSVRfWEFUVCA9
PSBXUklUX1hBVFQ6CgkJCXNlbGYuYmZfYWR2X3dlLnNlbGVjdCgpCgkJZWxzZToKCQkJc2VsZi5i
Zl9hZHZfd2UuZGVzZWxlY3QoKQoJCWlmIGFjZS5tYXNrICYgREVMRSA9PSBERUxFOgoJCQlzZWxm
LmJmX2Fkdl9kZS5zZWxlY3QoKQoJCWVsc2U6CgkJCXNlbGYuYmZfYWR2X2RlLmRlc2VsZWN0KCkK
CQlpZiBhY2UubWFzayAmIFJFQURfUEVSTSA9PSBSRUFEX1BFUk06CgkJCXNlbGYuYmZfYWR2X3Jw
LnNlbGVjdCgpCgkJZWxzZToKCQkJc2VsZi5iZl9hZHZfcnAuZGVzZWxlY3QoKQoJCWlmIGFjZS5t
YXNrICYgQ0hBTl9QRVJNID09IENIQU5fUEVSTToKCQkJc2VsZi5iZl9hZHZfcnAuc2VsZWN0KCkK
CQllbHNlOgoJCQlzZWxmLmJmX2Fkdl9ycC5kZXNlbGVjdCgpCgkJaWYgYWNlLm1hc2sgJiBUQUtF
X09XTlIgPT0gVEFLRV9PV05SOgoJCQlzZWxmLmJmX2Fkdl90by5zZWxlY3QoKQoJCWVsc2U6CgkJ
CXNlbGYuYmZfYWR2X3RvLmRlc2VsZWN0KCkKCglkZWYgdXBkYXRlX2JmX2JhcyhzZWxmKToKCQlh
Y2UgPSBzZWxmLnNkLmRhY2wuYWNlW3NlbGYubGIuY3Vyc2VsZWN0aW9uKClbMF1dCgkJc2VsZi5i
Zl9iYXNfbmFtZS5jb25maWcodGV4dD0nUGVybWlzc2lvbnMgZm9yICVzJyAlIChhY2Uuc2lkKSkK
CQl0bXAgPSBhY2UubWFzawoJCWlmIGFjZS5tYXNrID09IEZVTExfQ09OVFJPTDoKCQkJc2VsZi5i
Zl9iYXNfZmMuc2VsZWN0KCkKCQkJdG1wICY9IH5GVUxMX0NPTlRST0wKCQllbHNlOgoJCQlzZWxm
LmJmX2Jhc19mYy5kZXNlbGVjdCgpCgkJaWYgYWNlLm1hc2sgJiBDSEFOR0UgPT0gQ0hBTkdFOgoJ
CQlzZWxmLmJmX2Jhc19tby5zZWxlY3QoKQoJCQl0bXAgJj0gfkNIQU5HRQoJCWVsc2U6CgkJCXNl
bGYuYmZfYmFzX21vLmRlc2VsZWN0KCkKCQlpZiBhY2UubWFzayAmIEVSRUFEID09IEVSRUFEOgoJ
CQlzZWxmLmJmX2Jhc19yZS5zZWxlY3QoKQoJCQl0bXAgJj0gfkVSRUFECgkJZWxzZToKCQkJc2Vs
Zi5iZl9iYXNfcmUuZGVzZWxlY3QoKQoJCWlmIGFjZS5tYXNrICYgQUxMX1JFQURfQklUUyA9PSBB
TExfUkVBRF9CSVRTOgoJCQlzZWxmLmJmX2Jhc19yZC5zZWxlY3QoKQoJCQl0bXAgJj0gfkFMTF9S
RUFEX0JJVFMKCQllbHNlOgoJCQlzZWxmLmJmX2Jhc19yZC5kZXNlbGVjdCgpCgkJaWYgYWNlLm1h
c2sgJiBFV1JJVEUgPT0gRVdSSVRFOgoJCQlzZWxmLmJmX2Jhc193ci5zZWxlY3QoKQoJCQl0bXAg
Jj0gfkVXUklURQoJCWVsc2U6CgkJCXNlbGYuYmZfYmFzX3dyLmRlc2VsZWN0KCkKCQlpZiB0bXA6
CgkJCXNlbGYuYmZfYmFzX3NwLnNlbGVjdCgpCgkJZWxzZToKCQkJc2VsZi5iZl9iYXNfc3AuZGVz
ZWxlY3QoKQoKQ0lGU19RVUVSWV9JTkZPID0gMHhjMDE4Y2YwNwoKZGVmIHVzYWdlKCk6CiAgICAg
ICAgcHJpbnQgIlVzYWdlOiAlcyA8ZmlsZW5hbWU+IiAlIChzeXMuYXJndlswXSkKICAgICAgICBz
eXMuZXhpdCgpCgpjbGFzcyBTSUQ6CiAgICAgICAgZGVmIF9faW5pdF9fKHNlbGYsIGJ1Zik6CiAg
ICAgICAgICAgICAgICBzZWxmLnN1Yl9hdXRob3JpdHlfY291bnQgPSBidWZbMV0KICAgICAgICAg
ICAgICAgIHNlbGYuYnVmZmVyID0gYnVmWzo4ICsgc2VsZi5zdWJfYXV0aG9yaXR5X2NvdW50ICog
NF0KICAgICAgICAgICAgICAgIHNlbGYucmV2aXNpb24gPSBzZWxmLmJ1ZmZlclswXQogICAgICAg
ICAgICAgICAgaWYgc2VsZi5yZXZpc2lvbiAhPSAxOgogICAgICAgICAgICAgICAgICAgICAgICBy
YWlzZSBWYWx1ZUVycm9yKCdTSUQgUmV2aXNpb24gJWQgbm90IHN1cHBvcnRlZCcgJQogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIChzZWxmLnJldmlzaW9uKSkKICAgICAg
ICAgICAgICAgIHNlbGYuaWRlbnRpZmllcl9hdXRob3JpdHkgPSAwCiAgICAgICAgICAgICAgICBm
b3IgeCBpbiBzZWxmLmJ1ZmZlclsyOjhdOgogICAgICAgICAgICAgICAgICAgICAgICBzZWxmLmlk
ZW50aWZpZXJfYXV0aG9yaXR5ID0gc2VsZi5pZGVudGlmaWVyX2F1dGhvcml0eSAqIDI1NiArIHgK
ICAgICAgICAgICAgICAgIHNlbGYuc3ViX2F1dGhvcml0eSA9IFtdCiAgICAgICAgICAgICAgICBm
b3IgaSBpbiByYW5nZShzZWxmLnN1Yl9hdXRob3JpdHlfY291bnQpOgogICAgICAgICAgICAgICAg
ICAgICAgICBzZWxmLnN1Yl9hdXRob3JpdHkuYXBwZW5kKHN0cnVjdC51bnBhY2tfZnJvbSgnPEkn
LCBzZWxmLmJ1ZmZlciwgOCArIDQgKiBpKVswXSkKCiAgICAgICAgZGVmIF9fc3RyX18oc2VsZik6
CiAgICAgICAgICAgICAgICBzID0gIlMtJXUtJXUiICUgKHNlbGYucmV2aXNpb24sIHNlbGYuaWRl
bnRpZmllcl9hdXRob3JpdHkpCgogICAgICAgICAgICAgICAgZm9yIHggaW4gc2VsZi5zdWJfYXV0
aG9yaXR5OgogICAgICAgICAgICAgICAgICAgICAgICBzICs9ICctJXUnICUgeAogICAgICAgICAg
ICAgICAgcmV0dXJuIHMKCgpjbGFzcyBBQ0U6CiAgICAgICAgZGVmIF9faW5pdF9fKHNlbGYsIGJ1
Zik6CiAgICAgICAgICAgICAgICBzZWxmLnR5cGUgPSBidWZbMF0KICAgICAgICAgICAgICAgIHNl
bGYuZmxhZ3MgPSBidWZbMV0KICAgICAgICAgICAgICAgIHNlbGYuc2l6ZSA9IHN0cnVjdC51bnBh
Y2tfZnJvbSgnPEgnLCBidWYsIDIpWzBdCiAgICAgICAgICAgICAgICBzZWxmLnJhdyA9IGJ1Zls6
c2VsZi5zaXplXQogICAgICAgICAgICAgICAgaWYgc2VsZi50eXBlIGluIFswLCAxXToKICAgICAg
ICAgICAgICAgICAgICAgICAgc2VsZi5tYXNrID0gc3RydWN0LnVucGFja19mcm9tKCc8SScsIGJ1
ZiwgNClbMF0KICAgICAgICAgICAgICAgICAgICAgICAgc2VsZi5zaWQgPSBTSUQoYnVmWzg6XSkK
CiAgICAgICAgZGVmIF9fc3RyX18oc2VsZik6CiAgICAgICAgICAgICAgICBzID0gJ1R5cGU6MHgl
MDJ4ICcgJSAoc2VsZi50eXBlKQogICAgICAgICAgICAgICAgcyArPSAnRmxhZ3M6MHglMDJ4ICcg
JSAoc2VsZi5mbGFncykKICAgICAgICAgICAgICAgIGlmIHNlbGYudHlwZSBpbiBbMCwgMV06CiAg
ICAgICAgICAgICAgICAgICAgICAgIHMgKz0gJ01hc2s6MHglMDJ4IFNJRDolcycgJSAoc2VsZi5t
YXNrLCBzZWxmLnNpZCkKICAgICAgICAgICAgICAgIGVsc2U6CiAgICAgICAgICAgICAgICAgICAg
ICAgIGZvciBpIGluIHNlbGYucmF3WzQ6XToKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBzICs9ICclMDJ4JyAlIChpKQoKICAgICAgICAgICAgICAgIHJldHVybiBzCgogICAgICAgIGNs
YXNzIFR5cGUoZW51bS5FbnVtKToKICAgICAgICAgICAgICAgIEFMTE9XRUQgPSAwCiAgICAgICAg
ICAgICAgICBERU5JRUQgPSAxCgogICAgICAgICAgICAgICAgZGVmIF9fc3RyX18oc2VsZik6CiAg
ICAgICAgICAgICAgICAgICAgICAgIHJldHVybiBzZWxmLm5hbWUKCmNsYXNzIEFDTDoKICAgICAg
ICBkZWYgX19pbml0X18oc2VsZiwgYnVmKToKICAgICAgICAgICAgICAgIHNlbGYucmV2aXNpb24g
PSBidWZbMF0KICAgICAgICAgICAgICAgIGlmIHNlbGYucmV2aXNpb24gIT0gMiBhbmQgc2VsZi5y
ZXZpc2lvbiAhPSA0OgogICAgICAgICAgICAgICAgICAgICAgICByYWlzZSBWYWx1ZUVycm9yKCdB
Q0wgUmV2aXNpb24gJWQgJwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICdub3Qgc3VwcG9ydGVkJyAlIChzZWxmLnJldmlzaW9uKSkKICAgICAgICAgICAgICAgIGFjbCA9
IGJ1Zls4OjggKyBzdHJ1Y3QudW5wYWNrX2Zyb20oJzxIJywgYnVmLCAyKVswXV0KICAgICAgICAg
ICAgICAgIHNlbGYuYWNlID0gW10KICAgICAgICAgICAgICAgIGZvciBpIGluIHJhbmdlKHN0cnVj
dC51bnBhY2tfZnJvbSgnPEgnLCBidWYsIDQpWzBdKToKICAgICAgICAgICAgICAgICAgICAgICAg
YWNlID0gQUNFKGFjbCkKICAgICAgICAgICAgICAgICAgICAgICAgc2VsZi5hY2UuYXBwZW5kKGFj
ZSkKICAgICAgICAgICAgICAgICAgICAgICAgYWNsID0gYWNsW2FjZS5zaXplOl0KCiAgICAgICAg
ZGVmIF9fc3RyX18oc2VsZik6CiAgICAgICAgICAgICAgICBzID0gJ1JldmlzaW9uOjB4JTAyeFxu
JyAlIChzZWxmLnJldmlzaW9uKQogICAgICAgICAgICAgICAgZm9yIGFjZSBpbiBzZWxmLmFjZToK
ICAgICAgICAgICAgICAgICAgICAgICAgcyArPSAnJXNcbicgJSAoYWNlKQogICAgICAgICAgICAg
ICAgcmV0dXJuIHMKCmNsYXNzIFNlY3VyaXR5RGVzY3JpcHRvcjoKICAgICAgICBkZWYgX19pbml0
X18oc2VsZiwgYnVmKToKICAgICAgICAgICAgICAgIHNlbGYucmV2aXNpb24gPSBidWZbMF0KICAg
ICAgICAgICAgICAgIGlmIHNlbGYucmV2aXNpb24gIT0gMToKICAgICAgICAgICAgICAgICAgICAg
ICAgcmFpc2UgVmFsdWVFcnJvcignU2VjdXJpdHkgRGVzY3JpcHRvciBSZXZpc2lvbiAlZCAnCiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgJ25vdCBzdXBwb3J0ZWQnICUg
KHNlbGYucmV2aXNpb24pKQogICAgICAgICAgICAgICAgc2VsZi5jb250cm9sID0gc3RydWN0LnVu
cGFja19mcm9tKCc8SCcsIGJ1ZiwgMikKCiAgICAgICAgICAgICAgICBzZWxmLm93bmVyID0gU0lE
KGJ1ZltzdHJ1Y3QudW5wYWNrX2Zyb20oJzxJJywgYnVmLCA0KVswXTpdKQogICAgICAgICAgICAg
ICAgc2VsZi5ncm91cCA9IFNJRChidWZbc3RydWN0LnVucGFja19mcm9tKCc8SScsIGJ1ZiwgOClb
MF06XSkKCiAgICAgICAgICAgICAgICBzZWxmLmRhY2wgPSBBQ0woYnVmW3N0cnVjdC51bnBhY2tf
ZnJvbSgnPEknLCBidWYsIDE2KVswXTpdKQoKICAgICAgICBkZWYgX19zdHJfXyhzZWxmKToKICAg
ICAgICAgICAgICAgIHMgPSAnUmV2aXNpb246JXVcbicgJSAoc2VsZi5yZXZpc2lvbikKICAgICAg
ICAgICAgICAgIHMgKz0gJ0NvbnRyb2w6MHglMDR4XG4nICUgKHNlbGYuY29udHJvbCkKICAgICAg
ICAgICAgICAgIHMgKz0gJ093bmVyOiVzXG4nICUgKHNlbGYub3duZXIpCiAgICAgICAgICAgICAg
ICBzICs9ICdHcm91cDolc1xuJyAlIChzZWxmLmdyb3VwKQogICAgICAgICAgICAgICAgcyArPSAn
REFDTDpcbiVzJyAlIChzZWxmLmRhY2wpCiAgICAgICAgICAgICAgICByZXR1cm4gcwoKZGVmIG1h
aW4oKToKICAgICAgICBpZiBsZW4oc3lzLmFyZ3YpICE9IDI6CiAgICAgICAgICAgICAgICB1c2Fn
ZSgpCgogICAgICAgIGJ1ZiA9IGFycmF5LmFycmF5KCdCJywgWzBdICogMTYzODQpCgogICAgICAg
IHN0cnVjdC5wYWNrX2ludG8oJzxJJywgYnVmLCAwLCAzKSAjIEluZm9UeXBlOiBTZWN1cml0eQog
ICAgICAgIHN0cnVjdC5wYWNrX2ludG8oJzxJJywgYnVmLCA4LCA3KSAjIEFkZEluZm86IEdyb3Vw
L093bmVyL0RhY2wKICAgICAgICBzdHJ1Y3QucGFja19pbnRvKCc8SScsIGJ1ZiwgMTYsIDE2Mzg0
KSAjIElucHV0QnVmZmVyTGVuZ3RoCiAgICAgICAgCiAgICAgICAgI3dpdGggb3BlbihzeXMuYXJn
dlsxXSwgJ3InKSBhcyBmOgogICAgICAgIGYgPSBvcy5vcGVuKHN5cy5hcmd2WzFdLCBvcy5PX1JE
T05MWSkKICAgICAgICBzdCA9IG9zLmZzdGF0KGYpCiAgICAgICAgZmNudGwuaW9jdGwoZiwgQ0lG
U19RVUVSWV9JTkZPLCBidWYsIDEpCglvcy5jbG9zZShmKQoKICAgICAgICBzID0gc3RydWN0LnVu
cGFja19mcm9tKCc8SScsIGJ1ZiwgMTYpCgogICAgICAgIHNkID0gU2VjdXJpdHlEZXNjcmlwdG9y
KGJ1ZlsyNDoyNCArIHNbMF1dKQoKICAgICAgICByb290ID0gVGsoKQogICAgICAgIGFwcCA9IEFw
cChyb290LCBzZCwgc3RhdC5TX0lTRElSKHN0LnN0X21vZGUpKQogICAgICAgIHJvb3QubWFpbmxv
b3AoKQoKCmlmIF9fbmFtZV9fID09ICJfX21haW5fXyI6CgltYWluKCkKCg==
--00000000000030ab54058570c60e--
