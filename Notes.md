# Adolfo Nava Code Review Notes (Front-End Focused)

Overall I don't think in terms of the front end there is much things here that I would suggest that would make you present a stronger front-end candidate but I think there's a few smaller things that can go a long way.

## HTML Naming Element Principles 

When you work with front end elements something that could put you ahead of other applicants for job is REALLY trying to work with the inspector tools on the browser there are accessibility indicators, I will leave resources here that can help you understand what I mean using the tools other people tend to use to navigate a website as easily as we do. It's something I'm not the best with personally but I do acknowledge how quickly people can be disengaged with content if it feels like its not being made with them (the user) in mind. This is a very deep rabbit hole that someone who wants to develop more on the front end should at least go through yourself to make you a better developer in the current market. You were given credit for using ARIA attributes but, for the sake of your growth this could be a good subject to jump to next.

- [Accessible Rich Internet Applications (ARIA)](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA)
- [Digital Screen Reading Demo](https://youtu.be/dEbl5jvLKGQ?si=tG0O4f8DnJAuYM-R)
- [Color Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [Learn Accessibility - Full a11y Tutorial (FreeCodeCamp)](https://www.youtube.com/watch?v=e2nkq3h1P68)
- [The Only Accessibility video You will Ever Need](https://www.youtube.com/watch?v=2oiBKSjOOFE)

## Overall Styling

I really like how the website looks overall with a very consistent color scheme across the website and acknowledging as many pages as possible. 

Consider working on dark mode counterpart there are built-in CSS functions that you can look here in the reference link to try incorporate a different visual experience. I also acknowledge that this will be a bigger task than what I'm bringing forth with you but I think this is something that might be expect of you to make especially if its for a new website.

[Light and Dark Mode (light-dark())](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/color_value/light-dark)

## Navbar

On the subject of accessibility the contrast ratio for the navbar was 4.56:1 The optimal ratio is being greater than 7:1. The navbar seems like to be minimal in taking space but I think you can and should align the items vertically down after the users click on the navbar instead of horizontally.

## Unit Conversions

So for the feature that you personally wanted to implement first in the project there are two ways to handle this logic: 

Back-end or Front-end

Either way you would have to consider more information depending on how big are the individual ingredients could become but that will take time and thorough research to make sure this would align with chefs who makes food for a living. Regardless of which option you chose you have to make firm choices on how that data gets represented and commit to them. There is absolutely nothing worse thing to do regardless of how often this happens than it is to rework the UI without solid reason.

### Back-End 

Making requests to the server everytime a user wants to switch the measurements back and forth could be taxing on the server based on the amount of data that will have to go through the calculations. I think this approach is worse of the two options and that is because you can force the processing power onto the user instead using front-end.

### Front-End

You can make the client's machines handle the logic of the unit conversion by making sure of front end js packages like old fashioned way using DOM manipulation or stimulus. Both of these approaches doesn't put the burden to the server and lets users switch as much as they want to without costing your website more and more from more traffic. You should be able to handle the visual aspects of the website best working with stimulus.

### Logic

The simplist way to handle the logic is by categorizing the portions size based on the numeric values is by using switch cases and if-else statements that portions them to a reasonable visual indiciator.
