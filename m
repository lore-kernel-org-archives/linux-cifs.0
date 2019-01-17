From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 7/9] smb3: Cleanup license mess
Date: Fri, 18 Jan 2019 00:14:23 +0100
Message-ID: <20190117231501.453156872@linutronix.de>
References: <20190117231416.111952141@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Precise and non-ambiguous license information is important. The recently
added aegis header file has a SPDX license identifier, which is nice, but
at the same time it has a contradictionary license boiler plate text.

  SPDX-License-Identifier: GPL-2.0

versus 

  *   This program is free software;  you can redistribute it and/or modify
  *   it under the terms of the GNU General Public License as published by
  *   the Free Software Foundation; either version 2 of the License, or
  *   (at your option) any later version.

Oh well.

Assuming that the SPDX identifier is correct and according to x86/hyper-v
contributions from Microsoft GPL V2 only is the usual license.

Remove the boiler plate as it is wrong and even if correct it is redundant.

Fixes: eccb4422cf97 ("smb3: Add ftrace tracepoints for improved SMB3 debugging")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org
---

P.S.: This patch is part of a larger cleanup, but independent of other
      patches and is intended to be picked up by the maintainer directly.

---
 fs/cifs/trace.c |   10 ----------
 fs/cifs/trace.h |   10 ----------
 2 files changed, 20 deletions(-)

--- a/fs/cifs/trace.c
+++ b/fs/cifs/trace.c
@@ -3,16 +3,6 @@
  *   Copyright (C) 2018, Microsoft Corporation.
  *
  *   Author(s): Steve French <stfrench@microsoft.com>
- *
- *   This program is free software;  you can redistribute it and/or modify
- *   it under the terms of the GNU General Public License as published by
- *   the Free Software Foundation; either version 2 of the License, or
- *   (at your option) any later version.
- *
- *   This program is distributed in the hope that it will be useful,
- *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
- *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
- *   the GNU General Public License for more details.
  */
 #define CREATE_TRACE_POINTS
 #include "trace.h"
--- a/fs/cifs/trace.h
+++ b/fs/cifs/trace.h
@@ -3,16 +3,6 @@
  *   Copyright (C) 2018, Microsoft Corporation.
  *
  *   Author(s): Steve French <stfrench@microsoft.com>
- *
- *   This program is free software;  you can redistribute it and/or modify
- *   it under the terms of the GNU General Public License as published by
- *   the Free Software Foundation; either version 2 of the License, or
- *   (at your option) any later version.
- *
- *   This program is distributed in the hope that it will be useful,
- *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
- *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
- *   the GNU General Public License for more details.
  */
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM cifs
