From: blueduck-GANU6spQydw@public.gmane.org
Subject: Ubuntu SecurityFlags at boot
Date: Sun, 5 Aug 2012 13:31:22 +0200 (CEST)
Message-ID: <484724139.8236317.1344166282900.JavaMail.root@zimbra76-e14.priv.proxad.net>
References: <S1753625Ab2HELY7/20120805112459Z+242@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <S1753625Ab2HELY7/20120805112459Z+242-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

Looking at fs/cifs/README, I managed to mount shares with plaintext passwords (using Kubuntu 12.04) with "echo 0x30030 > /proc/fs/cifs/SecurityFlags". But it as to be done after each boot.

Is there any configuration file to modify to make the change permanent?

Regards.
