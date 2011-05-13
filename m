From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: mapchars option is completely broken in 2.6.38
Date: Fri, 13 May 2011 05:32:34 +0200
Message-ID: <1305257555-20656-1-git-send-email-metze@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

here is a fix that lets the mapchars option work again for me
in 2.6.38. Without this patch the string contains only zero bytes.

metze
