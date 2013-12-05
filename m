From: Patrick Noffke <patrick-0qqNeQ6W4hOzQB+pC5nmwQ@public.gmane.org>
Subject: Re: hung system with cifsd, cannot reduce timeout
Date: Thu, 05 Dec 2013 15:36:11 -0600
Message-ID: <52A0F1CB.5060709@noffke.me>
References: <52A0EA24.9000600@noffke.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52A0EA24.9000600-0qqNeQ6W4hOzQB+pC5nmwQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 12/05/2013 03:03 PM, Patrick Noffke wrote:
> Hi,
>
> I did check the cifsd stack (cat /proc/<cifsd PID>/stack) for previous
> tests, and it was waiting on a recv, and its state was SW (not DW).
> Unfortunately, I did not get the stack for this test.
>
I just repeated this test, and this time cifsd was in the SW state.

The stack was as follows:
sk_wait_data
tcp_recvmsg
inet_recvmsg
sock_recvmsg
kernel_recvmsg
cifs_readv_from_socket
cifs_read_from_socket
cifs_readv_discard
cifs_readv_receive
cifs_demultiplex_thread
kthread
ret_from_fork

For this test, my process and ps were hung after the first time pulling 
the cable (I hadn't rebooted from my earlier test, but I think the CIFS 
connection had disconnected due to inactivity).

As before, an Echo Request was sent on a previous connection after 
sending the SYN and Negotiate on a new connection.  The server RST the 
old connection right after the Echo Request, and 115 seconds later RST 
the new connection.  Another new connection was then made, and the 
process resumed and ps completed.

Patrick
