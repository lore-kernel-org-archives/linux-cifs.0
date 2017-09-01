From: Leif Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Missing patch for reconnect during NegotiateProtocol
Date: Thu, 31 Aug 2017 21:08:06 -0400 (EDT)
Message-ID: <2028844886.3790430.1504228086410.JavaMail.zimbra@redhat.com>
References: <448928481.3790365.1504227862030.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <448928481.3790365.1504227862030.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Steven,

Please add a Reviewed-by: Ronnie Sahlberg <lsahlber-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
for the patch in the link below :

http://www.spinics.net/lists/linux-cifs/msg12842.html


I have tested this patch using samba and iptables.


Testing :
Connect to an smb2 share.
On server, add these iptable rules :

sudo iptables -I INPUT 1 -p tcp --dport 445 --tcp-flags SYN,RST,ACK,FIN SYN -j ACCEPT
sudo iptables -I INPUT 2 -p tcp --dport 445 -j DROP

Eventually the Keepalives that are not responded to result in a TCP session reconnect
followed by a Negotiate Protocol request.

With this patch, every few minutes the client will reconnect a new TCP session and try NegotiateProtocol again.

Without this patch, the client is stuck waiting for the first Negotiate Protocol forever.


regards
ronnie sahlberg
