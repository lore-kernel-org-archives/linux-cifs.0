From: Maciej Rutecki <maciej.rutecki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [OOPS] 3.0-rc1 cifs
Date: Wed, 15 Jun 2011 21:55:47 +0200
Message-ID: <201106152155.48167.maciej.rutecki@gmail.com>
References: <Pine.LNX.4.64.1106092211500.19687@sarijopen.student.utwente.nl>
Reply-To: maciej.rutecki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Martijn Uffing <mp3project-dT/mdtNybfnOcQoxchNua+fsyHJTGBv43KldkOmuLK4@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1106092211500.19687-dT/mdtNybfnOcQoxchNua+fsyHJTGBv43KldkOmuLK4@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On czwartek, 9 czerwca 2011 o 22:15:05 Martijn Uffing wrote:
> Ave People
> 
> 
> I've got an oops with 3.0-rc1. (The same Oops also occurs with 3.0-rc2 and
> the git snapshot of today linux-2.6-06e8684.)
> The Oops occurs at boot time while the boot scripts try to automount a
> samba share.
> 
> Last (tested)  working kernel	:	2.6.39
> First (tested) oopsing kernel	:	3.0-rc1

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=37542
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
