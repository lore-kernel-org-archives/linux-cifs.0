From: Bill Good <bgood-mO0wGsvBftXk1uMJSBkQmQ@public.gmane.org>
Subject: Can't mount CIFS shares under kernel version 3.0-1-generic
Date: Tue, 21 Jun 2011 21:29:54 -0400
Message-ID: <4E014592.3070209@velocity.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I have been trying to get this working for a couple of days and 
according to the LinuxCIFS troubleshooting page this is where I should 
be asking my question. I am testing Ubuntu Oneiric (11.10) and have a 
new D-Link DNS-320 ShareCenter that I am trying to get to mount on 
3.0-1-generic. It is working fine on 2.6.39-02063901-generic so thinking 
there is something that changed when we moved to the 3.0 kernel. If I am 
in the wrong place please let me know I will find the correct place. I 
have included the info that was suggested from the above mentioned page.

bill@billsim-1110-64:~$ uname -r
3.0-1-generic
bill@billsim-1110-64:~$ mount.cifs -V
mount.cifs version: 4.9

When using the command
sudo mount -t cifs -o guest //192.168.0.189/Volume_1/test/ 
/media/bills-dns-game-1110-64test
with Ubuntu 11.10 kernel 3.0-1-generic it fails to mount.

If I use the same mount command with Ubuntu 11.10 kernel 
2.6.39-02063901-generic
It mounts correctly.

D-Link DNS-320 ShareCenter NAS

Thanks Bill
