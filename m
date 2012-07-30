From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: file_mode, dir_mode ignored when unix extensions are negotiated?
Date: Mon, 30 Jul 2012 17:41:27 +0530
Message-ID: <501679EF.7070507@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Do we ignore file_mode and dir_mode options when the unix extensions
have been negotiated? On a 3.1 based kernel, I see file_mode, dir_mode
options are not being honoured when mounting a Samba Server (Linux) with
unix extensions enabled. So, the expected behavior is to get the mode
from the server and not allow the client to override the modes?

This behavior looks different from the smbfs behavior. I couldn't
recollect or find from mailing list threads why it has done to be this
way. Could someone please enlighten me?


Thanks
Suresh
