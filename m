From: Patrick Noffke <patrick-0qqNeQ6W4hOzQB+pC5nmwQ@public.gmane.org>
Subject: hung system with cifsd, cannot reduce timeout
Date: Thu, 05 Dec 2013 15:03:32 -0600
Message-ID: <52A0EA24.9000600@noffke.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I am having problems similar to those described here:
http://article.gmane.org/gmane.linux.kernel.cifs/9024

My system is an embedded Linux, kernel version 3.9.0, and the CIFS 
server is Windows Server 2003, SP1.  I can somewhat reliably produce a 
system that hangs for about three minutes, then recovers.  I would like 
to reduce this time, if possible (to more quickly recover under link 
failures or other conditions that cause the server to not respond).

I tried changing SMB_ECHO_INTERVAL to 5 seconds (5 * HZ).  This appears 
to be working for part of cifs, but I think there is another socket that 
is still open, and doesn't disconnect until about two minutes later when 
the server sends a RST.

Here is my sequence of actions:

1. Start lengthy process that accesses files on CIFS mount.
2. Pull Ethernet cable.
3. Wait about 20 seconds (with SMB_ECHO_INTERVAL at 5 seconds), then 
reconnect cable.  Process resumes almost immediately accessing files on 
CIFS mount.
4. Pull Ethernet cable again.
5. Wait about 20 seconds, then reconnect cable.  Process is hung. ps is 
also hung, printing everything before but not including the hung 
process.  cifsd was reported to have state DW (it has a PID before my 
process, so it was printed in the ps output).
6. About 165 seconds later, the hung process resumes, and the system is 
functioning normally.

I have a wireshark capture for the above sequence.  I will try to 
describe the packet sequence corresponding to each of the above steps 
(except 1).

2. Last packet successfully transmitted is from server to client, which 
is a TCP segment of a reassembled PDU.  There are several 
retransmissions of packets from the server (when I pull the plug, I can 
still see packets from the server, since it is running on the same 
machine as wireshark).
3. Client sends new SYN packet (source port 43480), followed by 
Negotiate Protocol Request, followed by session setup and so forth (the 
server is responding as appropriate for client requests).
4. Last packet successfully transmitted is from server to client, and is 
a Read AndX Response, FID:  0x800f.  Again, there are several 
retransmissions from server to client.
5. Client sends new SYN packet (source port 43492), followed by 
Negotiate Protocol Request.
  - Server replies with Negotiate Protocol Request.
  - Then nothing for about 9 seconds.
  - Client sends Echo Request *on previous TCP connection* (the one that 
had retransmissions in step 4, source port 43480).
  - Server sends RST for previous TCP connection (dest port 43480).
  - Then nothing for 111 sec, when server sends TCP keep-alive (this is 
also 120 seconds after Negotiate sequence, which is probably the 
configured TCP keep-alive interval).
  - Client ACKs keep-alive immediately.
  - 35 seconds later, server sends RST for new connection (dest port 43492).
  - Client immediately sends new SYN packet.
6. 10 seconds after last SYN packet, client Negotiate Protocol Request, 
and normal communication resumes.

I do see klog messages that the CIFS server has not responded in 10 
seconds (twice SMB_ECHO_INTERVAL, as expected), and that it is 
reconnecting.  I believe these correspond to the first two SYN packets 
above, but it is hard to correlate those timestamps to wireshark, so I 
can't be sure.  But the last such log occurred 177 seconds before my 
process resumed working, which makes me think the logs correlate to the 
first two SYN packets.

Why would the Echo Request go out on the old connection after a new 
connection has been opened?  And why are there no Echo Requests on the 
new connection?

I did check the cifsd stack (cat /proc/<cifsd PID>/stack) for previous 
tests, and it was waiting on a recv, and its state was SW (not DW).  
Unfortunately, I did not get the stack for this test.

Please let me know if there's any more information I can provide.

Also, is reducing SMB_ECHO_INTERVAL expected to reduce the recovery time 
under such failures?  If so, should the total time to reconnect to the 
server be 2 * SMB_ECHO_INTERVAL, or are there other timeouts on top of this?

Best regards,
Patrick
