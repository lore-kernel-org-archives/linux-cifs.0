From: Valentin Hilbig <externer.dl.hilbig-EnyPcy3oyxIb1SvskN2V4Q@public.gmane.org>
Subject: Linux CIFS client module: login rate limiting
Date: Thu, 19 Jan 2017 08:48:09 +0100
Message-ID: <58806F39.9010801@muenchen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello Linux Kernel CIFS-List,

please forgive me to ninja-register to the list and start my firstpost 
right with the questions.  This is done in the hope to save your time. 
The long background story is below in case you are interested:

Q1) Is it possible on the CIFS client to implement caching for failed 
CIFS/SMB authentication replies?  My wish is to cache those negative 
replies just a second (HZ), as 3600 retries per hour to re-establish a 
lost connection to a CIFS server seems enough.  Enough to succeed and 
enough on semi-permanent failures.  I'd like to see this 1000ms cache as 
a mount default, as it's not for the initial request, just for the 
subsequent retries, but setting it to 0 (no cache) is ok for me, too, as 
it then can be changed at mount-time.

Q2) As an extension I also would like to see something like a maximum 
retry counter, which declares a CIFS mount dead if we do not succeed 
after N negative replies.  In my case N=40000 (around at least 11 hrs 
for 1s cache time) sounds good.  However the rate-limiting is much more 
important than deactivating a rogue CIFS mount.  Hence mount's default 
should be N=0, which means, infinite retries (as it is today).

Q3) According to 
https://www.kernel.org/doc/readme/Documentation-filesystems-cifs-README 
these features do not exist (yet).  Are such features planned for the 
kernel CIFS client module?  If not, is there a chance for me to get 
patches upstream in case that I provide them?  Is there more to think of 
than to just follow the style guide (and provide kernel-grade code)?  Of 
course I will extend the sysctl/proc interface to those new mount 
options in a compatible way (or discuss this with the list before I 
break heritage).  However my patches will be for "our" kernels used here 
(3.13 and 4.4), so perhaps this needs some porting/upgrading for the 
latest (I am not sure that I get permission to take the time to provide 
patches to the current kernel as well).

Sorry if some of those are FAQ, but as gmane.org is down/blank 
currently, I do not have access to the archive of kernel.cifs.

If you some better ideas, please feel free to criticize me ;)

Thanks,
-Tino
PS: FYI full long (sorry!) details follow in case you are interested:

(Sorry for missing logs and plain prose, I have no access to the test 
installation ATM, because it belongs to another group.)

Here at LiMux (Linux for Munich) in certain situations (for example the 
user has changed the password in LDAP) we observe, that CIFS clients 
might send 30 or more failing CIFS-setup-requests per second(!) to the 
CIFS server for an existing (old) CIFS-mount.  Each of this requests 
tries to (re-)authenticate against AD/LDAP but fails, because the 
credentials are no more valid.  After a short while the brute force 
protection of the AD kicks in and then blocks the AD-client (in this 
case the CIFS server) from accessing AD (for a while).  Which means, 
other clients are affected by the faulty CIFS-mounts and prohibited to 
authenticate against the CIFS server.

The CIFS-Server-people cannot help, as the CIFS' vendor (no, not 
Microsoft) tells us to switch off brute-force-protection on AD-side, 
which is something we do not want to do for obvious reasons.  The AD 
shall continue to block IPs with too many wrong requests.  So the only 
option we have is, to do something against the high rate of AD-requests 
with a wrong password coming from CIFS clients.

To observe the effect following must happen:

- There is an old CIFS mount (for example a User's $HOME), which is 
already successfully mounted and working.

- The TCP session to the CIFS server breaks (like inactivity or some 
short outage on the network.  I used "tcpkill" to simulate that), such 
that the Kernel's CIFS module needs to re-establish a connection to the 
CIFS server for the next access, which then triggers re-authenticating 
with the stored credentials.

- This re-authentication fails, due to a password change or locked 
account on the AD side.  (If it succeeds there will be no problem, as 
then the CIFS mount is back to fully functional.  The problem starts, 
when this re-authentication does not work.)

- And there also must be some culprit, in my case some user process (we 
haven't identified it yet but think it's something like Thunderbird), 
which tries to access the CIFS share in some looping fashion.  (I used 
"while sleep 0.1; do touch /path/to/share/FILE; done" to test it.)

Please note that there are too many possible user space applications out 
there which could rapidly hammer a defunct CIFS mount, such that you 
won't be able to fix them all.  Hence we need a fix on some other level.

(BTW we use version=1 of the protocol, and we require it, upgrading 18k 
of Linux workstations plus infrastructure against politics ain't easy.)

The CIFS module just forwards the request(s) to the CIFS server, and, as 
the TCP-connection is broken, tries to establish a new one.  This 
triggers authentication, but the authentication fails.  So the 
CIFS-client sees a negative reply like NT ACCOUNT LOCKED OUT, and 
answers something like "permission denied" to the userspace.  So far, so 
correct, everything works perfectly as it should!

The problem starts when some userspace application starts to loop over 
the fault, thereby accessing the CIFS share over and over again, several 
times a second.  Then the CIFS module continues to do it's job, but it 
does it much too perfect.  Each single userspace access will try to 
re-open the session to the CIFS server, again and again, which means we 
see a massive amount of authentication requests to the server which all 
are doomed.  Even worse, the faster the server and the better the 
network, the more such failing requests you will see, of course.  This 
triggers the AD brute force protection even faster.

However, if those few CIFS-clients, which "freak out", would be limited 
to only send 1 request per second, then AD does not see too many failed 
requests per timespan, so everything stays operable.

But even if this is implemented, this is only half of the story (the 
important half, but there is more to it):

If we had rate-limiting in place the AD and CIFS server are out of the 
loop.  But we still have the user account locked by the failing AD 
requests.  Let's start over the case from the beginning under the 
assumption, that we have failed authentication reply caching with a 1s 
retry:

- The user changes his password (perhaps using Windows, not Linux) but 
does not log out afterwards (on Linux).

- The TCP-session of the CIFS mount breaks for some reason.

- Some userspace process tries to access this CIFS mount in the looping 
fashion.

- The Kernel's CIFS-module tries to re-establish the connection.

- The requests fails due to old credential. (As above.  Windows has the 
new password, but Linux not.)

- After 5 such false retries (seen from the CIFS-Server) the AD locks 
the account.  Now the Linux-Client sees NT ACCOUNT LOCKED (sp?).  This 
takes 5 seconds.

- If the user comes back to work the next day and tries to login, his 
account is locked, of course.

- He calls Help Desk to get his account unlocked.  They do it.

- But 5s later his account is locked, again.  Thanks to 5 retries seen 
from the old login on the Linux client.

- Wash, rinse, repeat.

Eventually the user finds out where he is still logged in and logs out, 
such that (in our case) the (automated, yet no more working) user's 
CIFS-mounts vanish, too.  This delays how long it takes until the user 
can work normally, also it usually involves a lot of effort of other 
people to solve the riddle where the login hides.

This is why I asked Q2 which would allow us to configure, that after 11 
hours (or so) the CIFS mount ceases to exist, such that the CIFS client 
stops trying to re-establish the connection.  Which means, the next 
business day, the CIFS mount very likely has invalidated (it still is 
mounted, but quiet on the Linux side), such that the user can have his 
password unlocked without trouble.

This is a tripple-win situation, as it not only helps the Users and 
takes the burden from Help Desk to diagnose a hard do diagnose 
situation, it also conserves some wasted network bandwidth and 
processing power due to all those fruitless authentication requests seen 
today.  Sigh.

I agree that all this is not the fault of the CIFS module.  However it 
is better to start to be nice and polite to the infrastructure in case 
something stupid happens, than to continue as usual and thereby wasting 
resources and possibly impact others, even when you are rightfully doing 
this.

(This is a technical list, so I do not introduce myself, because I am 
not important.  All you need to know is that I know Linux from 0.99 and 
I am able to hack the kernel, but until now only for my very own needs. 
  BTW, my private GitHub is https://github.com/hilbix/)

Thanks for any help or comments,

-Tino

-- 
Mit freundlichen Grüßen
Valentin Hilbig
Externer Dienstleister

IT@M - Dienstleister für Informations- und Telekommunikationstechnik der 
Landeshauptstadt München
Geschäftsbereich Werkzeuge und Infrastruktur
Servicebereich Städtische Arbeitsplätze
Serviceteam LiMux-Arbeitsplatz I23
LiMux-Basisclient

Raum A2.030, Agnes-Pockels-Bogen 21, 80992 München

Tel.: +49 89 233-782273
E-Mail: externer.dl.hilbig-EnyPcy3oyxIb1SvskN2V4Q@public.gmane.org
