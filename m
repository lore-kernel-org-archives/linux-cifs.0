From: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>
Subject: Strange hardlink behavior with CIFS
Date: Mon, 18 Oct 2010 14:04:45 -0500
Message-ID: <1287428685.16450.282.camel@calx>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

With Linux 2.6.32-35 and either Windows or Samba in nounix mode,
hardlink counts can mysteriously disappear:

- create hardlink pair foo,bar
- stat foo -> nlink = 2
- open foo
- stat foo -> nlink = 1
- close
- wait or sync
- ls -l -> nlink = 2

Original report is here:

http://mercurial.selenic.com/bts/issue1866

-- 
Mathematics is the supreme nostalgia of our time.
